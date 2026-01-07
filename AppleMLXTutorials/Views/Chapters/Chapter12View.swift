import SwiftUI
import MLX
import MLXVLM
import MLXLMCommon
import UniformTypeIdentifiers

// MARK: - Shared VLM Manager (Singleton)

@MainActor
final class VLMManager: ObservableObject {
    static let shared = VLMManager()

    @Published var modelContainer: ModelContainer?
    @Published var isLoaded = false
    @Published var isLoading = false
    @Published var downloadProgress: Double = 0
    @Published var statusMessage: String = "Please download the model"

    private var currentModelName: String?

    private init() {}

    func loadModel(configuration: ModelConfiguration) async {
        // 같은 모델이 이미 로드되어 있으면 스킵
        if isLoaded && currentModelName == configuration.name {
            return
        }

        // 다른 모델이면 리셋
        if currentModelName != configuration.name {
            modelContainer = nil
            isLoaded = false
        }

        guard !isLoading else { return }

        isLoading = true
        downloadProgress = 0
        statusMessage = "Downloading model..."
        currentModelName = configuration.name

        do {
            let container = try await VLMModelFactory.shared.loadContainer(
                configuration: configuration
            ) { [weak self] progress in
                Task { @MainActor in
                    self?.downloadProgress = progress.fractionCompleted
                }
            }

            modelContainer = container
            isLoaded = true
            isLoading = false
            statusMessage = "✓ VLM Model Ready"
        } catch {
            isLoading = false
            statusMessage = "✗ Error: \(error.localizedDescription)"
        }
    }
}

/// Chapter 12: VLM 이미지 분석
struct Chapter12View: View {
    @StateObject private var vlmManager = VLMManager.shared
    @State private var selectedImage: NSImage?
    @State private var prompt: String = "Describe this image in detail."
    @State private var output: String = ""
    @State private var isGenerating = false
    @State private var selectedModelIndex: Int = 0

    private let modelOptions: [(name: String, config: ModelConfiguration, description: String)] = [
        ("SmolVLM 4bit", VLMRegistry.smolvlminstruct4bit, "~1GB - 가벼운 VLM (추천)"),
        ("Qwen2-VL 2B", VLMRegistry.qwen2VL2BInstruct4Bit, "~2GB - 범용 VLM"),
        ("FastVLM 0.5B", VLMRegistry.fastvlm, "~500MB - 초고속 VLM"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                descriptionSection
                Divider()
                modelSection
                Divider()
                imageSection
                Divider()
                promptSection
                Divider()
                outputSection
            }
            .padding(24)
        }
    }

    // MARK: - Description Section

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Overview", systemImage: "info.circle")
                .font(.title2.bold())

            Text("""
            **Vision Language Models (VLM)** are multimodal models that understand both images and text together.

            **What you can do in this chapter:**
            - Download and load VLM models
            - Upload and analyze images
            - Ask questions about images

            **Use cases:**
            - Generate photo descriptions
            - Recognize objects in images
            - Analyze documents/charts
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Model Section

    private var modelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("1. 모델 선택 및 다운로드", systemImage: "cpu")
                .font(.title2.bold())

            Picker("모델 선택", selection: $selectedModelIndex) {
                ForEach(0..<modelOptions.count, id: \.self) { index in
                    Text(modelOptions[index].name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .disabled(vlmManager.isLoading || isGenerating)

            Text(modelOptions[selectedModelIndex].description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)

            HStack(spacing: 16) {
                Button(action: loadModel) {
                    Label(
                        vlmManager.isLoaded ? "Model Ready" : "Download Model",
                        systemImage: vlmManager.isLoaded ? "checkmark.circle" : "arrow.down.circle"
                    )
                }
                .buttonStyle(.borderedProminent)
                .disabled(vlmManager.isLoading || isGenerating)

                if vlmManager.isLoading {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: vlmManager.downloadProgress)
                            .frame(width: 150)
                        Text("\(Int(vlmManager.downloadProgress * 100))% Downloading...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(spacing: 8) {
                Circle()
                    .fill(vlmManager.isLoaded ? .green : (vlmManager.isLoading ? .blue : .gray))
                    .frame(width: 10, height: 10)
                Text(vlmManager.statusMessage)
                    .font(.caption)
                    .foregroundStyle(vlmManager.isLoaded ? .primary : .secondary)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Image Section

    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("2. 이미지 선택", systemImage: "photo")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: selectImage) {
                    Label("Select Image", systemImage: "folder")
                }
                .buttonStyle(.bordered)
                .disabled(!vlmManager.isLoaded || isGenerating)

                Button(action: useSampleImage) {
                    Label("샘플 이미지", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.bordered)
                .disabled(!vlmManager.isLoaded || isGenerating)

                if selectedImage != nil {
                    Button(action: { selectedImage = nil }) {
                        Label("Clear", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
            }

            GroupBox {
                if let image = selectedImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 250)
                        .cornerRadius(8)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text(vlmManager.isLoaded ? "Select an image or use a sample image." : "Please download the model first.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                }
            }
            .frame(minHeight: 150)
        }
    }

    // MARK: - Prompt Section

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("3. 질문 입력", systemImage: "text.bubble")
                .font(.title2.bold())

            TextEditor(text: $prompt)
                .font(.system(.body, design: .monospaced))
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .disabled(!vlmManager.isLoaded || isGenerating)

            HStack(spacing: 8) {
                Text("Examples:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Describe") {
                    prompt = "Describe this image in detail."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Objects") {
                    prompt = "List all objects visible in this image."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Text/OCR") {
                    prompt = "Read and extract all text visible in this image."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Colors") {
                    prompt = "What are the main colors in this image?"
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .disabled(!vlmManager.isLoaded || isGenerating)

            HStack(spacing: 16) {
                Button(action: analyzeImage) {
                    Label("Analyze", systemImage: "sparkles")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!vlmManager.isLoaded || selectedImage == nil || isGenerating || prompt.isEmpty)

                if isGenerating {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Analyzing...")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("4. 분석 결과", systemImage: "doc.text")
                    .font(.title2.bold())

                Spacer()

                if !output.isEmpty {
                    Button(action: copyOutput) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)

                    Button(action: { output = "" }) {
                        Label("Clear", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
            }

            GroupBox {
                ScrollView {
                    if output.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "text.cursor")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("Select an image and press the 'Analyze' button.")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    } else {
                        Text(output)
                            .font(.body)
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
            }
            .frame(minHeight: 200)
        }
    }

    // MARK: - Actions

    private func loadModel() {
        let config = modelOptions[selectedModelIndex].config
        Task {
            await vlmManager.loadModel(configuration: config)
        }
    }

    private func selectImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image, .png, .jpeg]
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            if let image = NSImage(contentsOf: url) {
                selectedImage = image
            }
        }
    }

    private func useSampleImage() {
        // 앱 아이콘을 샘플 이미지로 사용
        if let iconURL = Bundle.main.url(forResource: "AppIcon", withExtension: "icns"),
           let icon = NSImage(contentsOf: iconURL) {
            selectedImage = icon
        } else {
            // 시스템 이미지 생성
            let size = NSSize(width: 256, height: 256)
            let image = NSImage(size: size)
            image.lockFocus()

            // 배경
            NSColor.systemBlue.setFill()
            NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

            // 텍스트
            let text = "MLX"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.boldSystemFont(ofSize: 72),
                .foregroundColor: NSColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            let textRect = NSRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)

            image.unlockFocus()
            selectedImage = image
        }
    }

    private func analyzeImage() {
        guard let container = vlmManager.modelContainer,
              let nsImage = selectedImage,
              let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else { return }

        isGenerating = true
        output = ""

        let currentPrompt = prompt
        // CGImage를 CIImage로 변환
        let ciImage = CIImage(cgImage: cgImage)

        Task {
            do {
                // UserInput에 이미지와 프롬프트 설정
                let userInput = UserInput(
                    prompt: currentPrompt,
                    images: [.ciImage(ciImage)]
                )

                let input = try await container.prepare(input: userInput)

                let parameters = GenerateParameters(
                    maxTokens: 500,
                    temperature: 0.7,
                    topP: 0.9
                )

                // 스트리밍 생성
                let stream = try container.generate(
                    input: input,
                    parameters: parameters
                )

                for try await generation in stream {
                    switch generation {
                    case .chunk(let text):
                        await MainActor.run {
                            output += text
                        }
                    case .info, .toolCall:
                        break
                    }
                }

                await MainActor.run {
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    output = "Error occurred: \(error.localizedDescription)"
                    isGenerating = false
                }
            }
        }
    }

    private func copyOutput() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(output, forType: .string)
    }
}

#Preview {
    Chapter12View()
        .frame(width: 900, height: 900)
}
