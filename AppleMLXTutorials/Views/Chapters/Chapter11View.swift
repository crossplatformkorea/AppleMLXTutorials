import SwiftUI
import MLX
import MLXLLM
import MLXLMCommon

/// Chapter 11: LLM Text Generation
struct Chapter11View: View {
    @State private var prompt: String = "Tell me 3 advantages of the Swift programming language."
    @State private var output: String = ""
    @State private var isLoading = false
    @State private var isGenerating = false
    @State private var modelLoaded = false
    @State private var downloadProgress: Double = 0
    @State private var statusMessage: String = "Please download the model"
    @State private var selectedModelIndex: Int = 1  // Default: Qwen2.5 (Multilingual)

    @State private var llmModel: ModelContainer?

    private let modelOptions: [(name: String, id: String, description: String)] = [
        ("SmolLM 135M", "mlx-community/SmolLM-135M-Instruct-4bit", "~76MB - English only, for testing"),
        ("Qwen2.5 0.5B", "mlx-community/Qwen2.5-0.5B-Instruct-4bit", "~400MB - Multilingual (Recommended)"),
        ("Llama 3.2 1B", "mlx-community/Llama-3.2-1B-Instruct-4bit", "~700MB - English optimized"),
        ("Phi-3.5 Mini", "mlx-community/Phi-3.5-mini-instruct-4bit", "~2GB - High quality"),
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
            Label("1. Model Selection & Download", systemImage: "cpu")
                .font(.title2.bold())

            // Model Selection
            Picker("Select Model", selection: $selectedModelIndex) {
                ForEach(0..<modelOptions.count, id: \.self) { index in
                    Text(modelOptions[index].name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .disabled(isLoading || isGenerating)

            // Selected Model Description
            Text(modelOptions[selectedModelIndex].description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)

            // Download Button
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

            // Status Display
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
            Label("2. Enter Prompt", systemImage: "text.bubble")
                .font(.title2.bold())

            TextEditor(text: $prompt)
                .font(.system(.body, design: .monospaced))
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .disabled(!modelLoaded || isGenerating)

            // Example Prompt Buttons
            HStack(spacing: 8) {
                Text("Examples:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("General Question") {
                    prompt = "What is the capital of France and its population?"
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Code Request") {
                    prompt = "Show me how to sort an array in Swift with code."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Creative Writing") {
                    prompt = "Write a short poem about cherry blossoms in spring."
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .disabled(!modelLoaded || isGenerating)

            // Generate Button
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
                        // TODO: Cancel functionality
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
                Label("3. Generated Result", systemImage: "doc.text")
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
                // Create LMInput using UserInput
                let userInput = UserInput(prompt: .init(currentPrompt))
                let lmInput = try await model.prepare(input: userInput)

                let parameters = GenerateParameters(
                    maxTokens: 200,
                    temperature: 0.7,
                    topP: 0.9,
                    repetitionPenalty: 1.1,
                    repetitionContextSize: 64
                )

                // Generate tokens using AsyncStream
                let stream = try await model.generate(
                    input: lmInput,
                    parameters: parameters
                )

                // Receive tokens from stream and append to output
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
