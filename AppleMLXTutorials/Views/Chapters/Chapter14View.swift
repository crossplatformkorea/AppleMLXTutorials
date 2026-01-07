import SwiftUI
import MLX
import StableDiffusion

// MARK: - Shared Model Manager (Singleton)

@MainActor
final class StableDiffusionManager: ObservableObject {
    static let shared = StableDiffusionManager()

    @Published var modelContainer: ModelContainer<TextToImageGenerator>?
    @Published var isLoaded = false
    @Published var isLoading = false
    @Published var downloadProgress: Double = 0
    @Published var statusMessage: String = "Please download the model"

    let configuration = StableDiffusionConfiguration.presetSDXLTurbo

    private init() {}

    func loadModel() async {
        guard !isLoaded && !isLoading else { return }

        isLoading = true
        downloadProgress = 0
        statusMessage = "Downloading model..."

        do {
            // Download model
            try await configuration.download { [weak self] progress in
                Task { @MainActor in
                    self?.downloadProgress = progress.fractionCompleted
                }
            }

            statusMessage = "Loading model..."

            // Create model container
            let loadConfig = LoadConfiguration(float16: true, quantize: false)
            let container = try ModelContainer<TextToImageGenerator>.createTextToImageGenerator(
                configuration: configuration,
                loadConfiguration: loadConfig
            )

            // Preload model
            try await container.perform { generator in
                generator.ensureLoaded()
            }

            modelContainer = container
            isLoaded = true
            isLoading = false
            statusMessage = "✓ SDXL Turbo Model Ready"
        } catch {
            isLoading = false
            statusMessage = "✗ Error: \(error.localizedDescription)"
        }
    }
}

/// Chapter 14: 이미지 생성 (Stable Diffusion)
struct Chapter14View: View {
    @StateObject private var modelManager = StableDiffusionManager.shared
    @State private var prompt: String = "A beautiful sunset over mountains, digital art style"
    @State private var negativePrompt: String = "blurry, low quality, distorted"
    @State private var generatedImage: CGImage?
    @State private var isGenerating = false
    @State private var generationProgress: Double = 0
    @State private var generationSteps: Int = 0

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
            **Stable Diffusion** is a diffusion model that generates images from text prompts.

            **What you can do in this chapter:**
            - Download SDXL Turbo model (~5GB)
            - Generate images from text prompts
            - Remove unwanted elements with Negative Prompt

            **Note:**
            - Model download required on first run (~5GB)
            - SDXL Turbo offers fast generation (2-4 steps)
            - Minimum 8GB RAM recommended
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Model Section

    private var modelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("1. 모델 다운로드", systemImage: "cpu")
                .font(.title2.bold())

            Text("**SDXL Turbo** - 빠른 이미지 생성 (~5GB)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button(action: loadModel) {
                    Label(
                        modelManager.isLoaded ? "Model Ready" : "Download Model",
                        systemImage: modelManager.isLoaded ? "checkmark.circle" : "arrow.down.circle"
                    )
                }
                .buttonStyle(.borderedProminent)
                .disabled(modelManager.isLoading || isGenerating || modelManager.isLoaded)

                if modelManager.isLoading {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: modelManager.downloadProgress)
                            .frame(width: 150)
                        Text("\(Int(modelManager.downloadProgress * 100))% Downloading...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(spacing: 8) {
                Circle()
                    .fill(modelManager.isLoaded ? .green : (modelManager.isLoading ? .blue : .gray))
                    .frame(width: 10, height: 10)
                Text(modelManager.statusMessage)
                    .font(.caption)
                    .foregroundStyle(modelManager.isLoaded ? .primary : .secondary)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Prompt Section

    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("2. 프롬프트 입력", systemImage: "text.bubble")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text("Prompt (원하는 이미지 설명)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextEditor(text: $prompt)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .disabled(!modelManager.isLoaded || isGenerating)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Negative Prompt (제외할 요소)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextEditor(text: $negativePrompt)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .disabled(!modelManager.isLoaded || isGenerating)
            }

            // 예시 프롬프트 버튼들
            HStack(spacing: 8) {
                Text("Examples:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Landscape") {
                    prompt = "A serene Japanese garden with cherry blossoms, peaceful, detailed"
                    negativePrompt = "blurry, low quality"
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Portrait") {
                    prompt = "Portrait of a wise old wizard, fantasy style, detailed, magical"
                    negativePrompt = "blurry, distorted face, bad anatomy"
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Abstract") {
                    prompt = "Abstract colorful geometric patterns, vibrant, modern art"
                    negativePrompt = "realistic, photo"
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .disabled(!modelManager.isLoaded || isGenerating)

            HStack(spacing: 16) {
                Button(action: generateImage) {
                    Label("Generate Image", systemImage: "sparkles")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .disabled(!modelManager.isLoaded || isGenerating || prompt.isEmpty)

                if isGenerating {
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: generationProgress)
                            .frame(width: 100)
                        Text("Step \(generationSteps)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Output Section

    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("3. 생성 결과", systemImage: "photo")
                    .font(.title2.bold())

                Spacer()

                if generatedImage != nil {
                    Button(action: saveImage) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.bordered)

                    Button(action: copyImage) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)

                    Button(action: { generatedImage = nil }) {
                        Label("Clear", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                }
            }

            GroupBox {
                if let cgImage = generatedImage {
                    VStack(spacing: 12) {
                        Image(decorative: cgImage, scale: 1.0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 400)
                            .cornerRadius(8)

                        Text("512 × 512 pixels")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: modelManager.isLoaded ? "photo.badge.plus" : "arrow.down.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text(modelManager.isLoaded ? "Enter a prompt and press 'Generate Image' button." : "Please download the model above first.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                }
            }
            .frame(minHeight: 300)
        }
    }

    // MARK: - Actions

    private func loadModel() {
        Task {
            await modelManager.loadModel()
        }
    }

    private func generateImage() {
        guard let container = modelManager.modelContainer else { return }

        isGenerating = true
        generatedImage = nil
        generationProgress = 0
        generationSteps = 0

        let currentPrompt = prompt
        let currentNegativePrompt = negativePrompt
        let configuration = modelManager.configuration

        Task {
            do {
                try await container.performTwoStage { generator -> (ImageDecoder, DenoiseIterator, Int) in
                    // Setup parameters
                    var parameters = configuration.defaultParameters()
                    parameters.prompt = currentPrompt
                    parameters.negativePrompt = currentNegativePrompt
                    parameters.latentSize = [64, 64]  // 512x512 output

                    // Generate latents iterator
                    let latents = generator.generateLatents(parameters: parameters)
                    let decoder = generator.detachedDecoder()

                    return (decoder, latents, parameters.steps)

                } second: { (decoder: ImageDecoder, latents: DenoiseIterator, totalSteps: Int) in
                    var lastXt: MLXArray?
                    var stepCount = 0

                    for xt in latents {
                        lastXt = nil
                        eval(xt)
                        lastXt = xt
                        stepCount += 1

                        let currentStep = stepCount
                        Task { @MainActor in
                            generationSteps = currentStep
                            generationProgress = Double(currentStep) / Double(totalSteps)
                        }
                    }

                    // Decode final latent to image
                    if let finalXt = lastXt {
                        let decoded = decoder(finalXt)
                        let raster = (decoded * 255).asType(.uint8).squeezed()
                        eval(raster)

                        // Convert MLXArray to CGImage directly
                        let cgImage = rasterToCGImage(raster)

                        Task { @MainActor in
                            self.generatedImage = cgImage
                        }
                    }
                }

                await MainActor.run {
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    isGenerating = false
                }
            }
        }
    }

    private func saveImage() {
        guard let cgImage = generatedImage else { return }

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.nameFieldStringValue = "generated-image.png"

        savePanel.begin { result in
            if result == .OK, let url = savePanel.url {
                if let destination = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil) {
                    CGImageDestinationAddImage(destination, cgImage, nil)
                    CGImageDestinationFinalize(destination)
                }
            }
        }
    }

    private func copyImage() {
        guard let cgImage = generatedImage else { return }
        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([nsImage])
    }
}

// MARK: - Helper Functions

/// Convert MLXArray raster data to CGImage
private func rasterToCGImage(_ data: MLXArray) -> CGImage {
    var raster = data

    // We need 4 bytes per pixel (RGBA)
    if data.dim(-1) == 3 {
        raster = padded(raster, widths: [0, 0, [0, 1]])
    }

    class DataHolder {
        var data: Data
        init(_ data: Data) {
            self.data = data
        }
    }

    let holder = DataHolder(raster.asData(access: .copy).data)
    let payload = Unmanaged.passRetained(holder).toOpaque()

    func release(payload: UnsafeMutableRawPointer?, data: UnsafeMutableRawPointer?) {
        Unmanaged<DataHolder>.fromOpaque(payload!).release()
    }

    return holder.data.withUnsafeMutableBytes { ptr in
        let (H, W, C) = raster.shape3
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!

        let context = CGContext(
            data: ptr.baseAddress, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * C,
            space: cs,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
                | CGBitmapInfo.byteOrder32Big.rawValue, releaseCallback: release,
            releaseInfo: payload)!
        return context.makeImage()!
    }
}

#Preview {
    Chapter14View()
        .frame(width: 900, height: 900)
}
