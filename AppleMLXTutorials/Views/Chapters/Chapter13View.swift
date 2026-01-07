import SwiftUI
import MLX
import MLXLLM
import MLXLMCommon
import MLXOptimizers

/// Chapter 13: LoRA Fine-tuning
struct Chapter13View: View {
    @State private var output: String = ""
    @State private var isRunning = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                descriptionSection
                Divider()
                codeSection
                Divider()
                runSection
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
            **LoRA (Low-Rank Adaptation)** is a technique for efficiently fine-tuning large models.

            **LoRA Principle:**
            - Learn only low-rank matrices instead of all weights
            - W' = W + BA (B: d x r, A: r x k, r << min(d,k))
            - Original model weights remain frozen

            **Advantages:**
            - **Memory Efficient** - 1/10 memory of full fine-tuning
            - **Fast Training** - Significantly fewer trainable parameters
            - **Model Merging** - Can combine multiple LoRAs
            - **Storage** - Only save LoRA adapter (few MBs)

            **Use Cases:**
            - Domain specialization (medical, legal, finance)
            - Style adjustment (formal, casual)
            - Language adaptation (Korean enhancement)
            - Specific tasks (code generation, summarization)
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Code Section

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Code Example", systemImage: "chevron.left.forwardslash.chevron.right")
                .font(.title2.bold())

            Text("**1. LoRA Configuration and Application:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLXLLM
                import MLXLMCommon
                import MLXOptimizers

                // Load model
                let modelConfig = LLMRegistry.mistral7B4bit
                let modelContainer = try await LLMModelFactory.shared.loadContainer(
                    configuration: modelConfig
                )

                // LoRA configuration (default: 4 layers, rank 8)
                let loraConfig = LoRAConfiguration(numLayers: 4)

                // Apply LoRA adapter to model
                let loraAdapter = try await modelContainer.perform { context in
                    try LoRAContainer.from(
                        model: context.model,
                        configuration: loraConfig
                    )
                }
                """)

            Text("**2. Prepare Training Data (JSONL format):**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // train.jsonl example:
                // {"text": "<s>[INST] question [/INST] answer</s>"}
                // {"text": "<s>[INST] What is Swift? [/INST] It's Apple's programming language.</s>"}

                // Load JSONL files
                let trainData = try MLXLLM.loadLoRAData(url: trainURL)
                let validData = try MLXLLM.loadLoRAData(url: validURL)
                """)

            Text("**3. LoRA Training:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // Training parameters
                let parameters = LoRATrain.Parameters(
                    batchSize: 1,
                    iterations: 200
                )

                // Optimizer
                let optimizer = Adam(learningRate: 1e-5)

                // Run training
                try await modelContainer.perform { context in
                    try LoRATrain.train(
                        model: context.model,
                        train: trainData,
                        validate: validData,
                        optimizer: optimizer,
                        tokenizer: context.tokenizer,
                        parameters: parameters
                    ) { progress in
                        switch progress {
                        case .train(let i, let loss, _, _):
                            print("Step \\(i): loss = \\(loss)")
                        case .validation(let loss, _):
                            print("Validation: loss = \\(loss)")
                        default:
                            break
                        }
                        return .more  // continue training
                    }
                }
                """)

            Text("**4. LoRA Evaluation:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // Evaluate with test data
                let testLoss = await modelContainer.perform { context in
                    LoRATrain.evaluate(
                        model: context.model,
                        dataset: testData,
                        tokenizer: context.tokenizer,
                        batchSize: 1,
                        batchCount: 0
                    )
                }

                print("Test loss: \\(testLoss)")
                print("Perplexity: \\(exp(testLoss))")
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Run Info", systemImage: "play.circle")
                .font(.title2.bold())

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Label("LoRA Training Requirements", systemImage: "exclamationmark.triangle")
                        .font(.headline)
                        .foregroundStyle(.orange)

                    Text("""
                    To run LoRA fine-tuning:

                    1. **Sufficient Memory**
                       • 7B model LoRA: ~16GB RAM
                       • 1-3B model LoRA: ~8GB RAM

                    2. **Training Data**
                       • JSONL format required
                       • Minimum 100-1000 samples

                    3. **Training Time**
                       • 200 iterations: ~10-30 min
                       • GPU acceleration required (Apple Silicon)

                    **Official Example:**
                    Refer to LoRATrainingExample in mlx-swift-examples
                    """)
                    .font(.body)

                    Link(destination: URL(string: "https://github.com/ml-explore/mlx-swift-examples/tree/main/Applications/LoRATrainingExample")!) {
                        Label("View LoRA Training Example", systemImage: "arrow.up.right.square")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("LoRA Config Info", systemImage: "info.circle")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                if isRunning {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            if !output.isEmpty {
                GroupBox {
                    Text(output)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
        }
    }

    // MARK: - Actions

    private func runExample() {
        isRunning = true
        output = ""

        Task {
            var result = ""

            result += "== LoRA Fine-tuning Guide (mlx-swift-lm) ==\n\n"

            result += "Key Classes/Structs:\n"
            result += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
            result += "• LoRAConfiguration: LoRA settings\n"
            result += "  - numLayers: Number of layers to apply (default 4)\n"
            result += "  - rank: Low-rank dimension (default 8)\n\n"

            result += "• LoRAContainer: LoRA adapter management\n"
            result += "  - from(model:configuration:): Apply adapter\n\n"

            result += "• LoRATrain: Training utilities\n"
            result += "  - train(): Run training\n"
            result += "  - evaluate(): Model evaluation\n\n"

            result += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

            result += "Recommended Hyperparameters:\n"
            result += "• learning_rate: 1e-5\n"
            result += "• batch_size: 1-4\n"
            result += "• iterations: 100-500\n"
            result += "• numLayers: 4-8\n\n"

            result += "Data Format (JSONL):\n"
            result += "• One {\"text\": \"...\"} JSON object per line\n"
            result += "• Instruction format recommended:\n"
            result += "  <s>[INST] question [/INST] answer</s>\n\n"

            result += "Required Files:\n"
            result += "• train.jsonl: Training data\n"
            result += "• valid.jsonl: Validation data\n"
            result += "• test.jsonl: Test data"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter13View()
        .frame(width: 800, height: 800)
}
