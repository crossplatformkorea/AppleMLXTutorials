import SwiftUI
import MLX
import MLXLLM
import MLXLMCommon

/// Chapter 11: LLM 텍스트 생성 (실제 실행 가능)
struct Chapter11View: View {
    @State private var prompt: String = "Swift 프로그래밍 언어의 장점을 3가지 알려주세요."
    @State private var output: String = ""
    @State private var isLoading = false
    @State private var isGenerating = false
    @State private var modelLoaded = false
    @State private var downloadProgress: Double = 0
    @State private var statusMessage: String = "Please download the model"
    @State private var selectedModelIndex: Int = 1  // 기본값: Qwen2.5 (한국어 지원)

    @State private var llmModel: ModelContainer?

    private let modelOptions: [(name: String, id: String, description: String)] = [
        ("SmolLM 135M", "mlx-community/SmolLM-135M-Instruct-4bit", "~76MB - 영어만, 테스트용"),
        ("Qwen2.5 0.5B", "mlx-community/Qwen2.5-0.5B-Instruct-4bit", "~400MB - 한국어 지원 (추천)"),
        ("Llama 3.2 1B", "mlx-community/Llama-3.2-1B-Instruct-4bit", "~700MB - 영어 최적화"),
        ("Phi-3.5 Mini", "mlx-community/Phi-3.5-mini-instruct-4bit", "~2GB - 높은 품질"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                descriptionSection
                Divider()
                modelSection
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
            Run large language models on Apple Silicon using **MLXLLM**.

            **What you can do in this chapter:**
            - Auto-download models from Hugging Face
            - Generate AI text locally
            - Select and compare various models

            **Note:** Model download is required on first run (internet connection needed).
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

            // 모델 선택
            Picker("모델 선택", selection: $selectedModelIndex) {
                ForEach(0..<modelOptions.count, id: \.self) { index in
                    Text(modelOptions[index].name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .disabled(isLoading || isGenerating)

            // 선택된 모델 설명
            Text(modelOptions[selectedModelIndex].description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)

            // 다운로드 버튼
            HStack(spacing: 16) {
                Button(action: loadModel) {
                    Label(
                        modelLoaded ? "Replace Model" : "Download Model",
                        systemImage: modelLoaded ? "arrow.triangle.2.circlepath" : "arrow.down.circle"
                    )
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || isGenerating)

                if isLoading {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: downloadProgress)
                            .frame(width: 150)
                        Text("\(Int(downloadProgress * 100))% Downloading...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // 상태 표시
            HStack(spacing: 8) {
                Circle()
                    .fill(modelLoaded ? .green : (isLoading ? .blue : .gray))
                    .frame(width: 10, height: 10)
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(modelLoaded ? .primary : .secondary)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Prompt Section

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("2. 프롬프트 입력", systemImage: "text.bubble")
                .font(.title2.bold())

            TextEditor(text: $prompt)
                .font(.system(.body, design: .monospaced))
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .disabled(!modelLoaded || isGenerating)

            // 예시 프롬프트 버튼들
            HStack(spacing: 8) {
                Text("Examples:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Korean Question") {
                    prompt = "대한민국의 수도와 인구에 대해 알려주세요."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Code Request") {
                    prompt = "Swift에서 배열을 정렬하는 방법을 코드로 보여주세요."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Creative Writing") {
                    prompt = "봄날의 벚꽃에 대한 짧은 시를 써주세요."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .disabled(!modelLoaded || isGenerating)

            // 생성 버튼
            HStack(spacing: 16) {
                Button(action: generateText) {
                    Label("Generate Text", systemImage: "sparkles")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(!modelLoaded || isGenerating || prompt.isEmpty)

                if isGenerating {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Generating...")
                        .foregroundStyle(.secondary)

                    Button("Stop") {
                        // TODO: 취소 기능
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("3. 생성 결과", systemImage: "doc.text")
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
                            Image(systemName: modelLoaded ? "text.cursor" : "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text(modelLoaded ? "Enter a prompt and press 'Generate Text' button." : "Please download the model above first.")
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
        isLoading = true
        downloadProgress = 0
        statusMessage = "Checking model info..."
        modelLoaded = false
        llmModel = nil

        let selectedModel = modelOptions[selectedModelIndex]

        Task {
            do {
                let config = ModelConfiguration(id: selectedModel.id)

                statusMessage = "Downloading: \(selectedModel.name)..."

                let container = try await LLMModelFactory.shared.loadContainer(
                    configuration: config
                ) { progress in
                    Task { @MainActor in
                        downloadProgress = progress.fractionCompleted
                    }
                }

                await MainActor.run {
                    llmModel = container
                    modelLoaded = true
                    isLoading = false
                    statusMessage = "✓ Model Ready: \(selectedModel.name)"
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    statusMessage = "✗ Error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func generateText() {
        guard let model = llmModel else { return }

        isGenerating = true
        output = ""

        let currentPrompt = prompt

        Task {
            do {
                // UserInput을 사용하여 LMInput 생성
                let userInput = UserInput(prompt: .init(currentPrompt))
                let lmInput = try await model.prepare(input: userInput)

                let parameters = GenerateParameters(
                    maxTokens: 200,
                    temperature: 0.7,
                    topP: 0.9,
                    repetitionPenalty: 1.1,
                    repetitionContextSize: 64
                )

                // AsyncStream으로 토큰 생성
                let stream = try await model.generate(
                    input: lmInput,
                    parameters: parameters
                )

                // 스트림에서 토큰을 받아 출력에 추가
                for try await generation in stream {
                    switch generation {
                    case .chunk(let text):
                        await MainActor.run {
                            output += text
                        }
                    case .info:
                        break
                    case .toolCall:
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
    Chapter11View()
        .frame(width: 900, height: 800)
}
