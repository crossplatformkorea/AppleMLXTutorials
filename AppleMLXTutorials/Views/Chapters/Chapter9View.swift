import SwiftUI
import MLX
import MLXNN

/// Chapter 9: 모델 저장/로드
struct Chapter9View: View {
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
            Saving and loading trained models is essential for real-world applications.

            **Save Formats:**
            • **safetensors** - Recommended, safe and fast
            • **npz** - NumPy compatible
            • **gguf** - Commonly used for LLM models

            **What to Save:**
            • Model parameters (weights, biases)
            • Optimizer state (momentum, etc.)
            • Training checkpoints

            **MLX Save API:**
            • `save(arrays:url:)` - Save as safetensors
            • `loadArrays(url:)` - Load from file
            • `Module.parameters()` - Parameter dictionary

            **Checkpoints:**
            Save models during training to resume later or
            preserve the best performing model.
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

            Text("**Save Model Parameters:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // Create and train model
                let model = Linear(10, 2)

                // Extract parameters as dictionary
                let params = model.parameters()

                // Save in safetensors format
                let url = URL(fileURLWithPath: "/path/to/model.safetensors")
                try save(arrays: params.flattened(), url: url)
                """)

            Text("**Load Model Parameters:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // Create new model instance
                let model = Linear(10, 2)

                // Load saved parameters
                let url = URL(fileURLWithPath: "/path/to/model.safetensors")
                let loadedParams = try loadArrays(url: url)

                // Apply parameters to model
                try model.update(parameters: ModuleParameters.unflattened(loadedParams))
                """)

            Text("**Save Checkpoint:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // Save training state
                func saveCheckpoint(
                    model: Module,
                    optimizer: Adam,
                    epoch: Int,
                    path: String
                ) throws {
                    var checkpoint: [String: MLXArray] = [:]

                    // Model parameters
                    for (key, value) in model.parameters().flattened() {
                        checkpoint["model.\\(key)"] = value
                    }

                    // Epoch number
                    checkpoint["epoch"] = MLXArray(Int32(epoch))

                    let url = URL(fileURLWithPath: path)
                    try save(arrays: checkpoint, url: url)
                }

                // Load training state
                func loadCheckpoint(
                    model: Module,
                    path: String
                ) throws -> Int {
                    let url = URL(fileURLWithPath: path)
                    let checkpoint = try loadArrays(url: url)

                    // Restore model parameters
                    var modelParams: [String: MLXArray] = [:]
                    for (key, value) in checkpoint {
                        if key.hasPrefix("model.") {
                            let paramKey = String(key.dropFirst(6))
                            modelParams[paramKey] = value
                        }
                    }
                    try model.update(
                        parameters: ModuleParameters.unflattened(modelParams)
                    )

                    // Restore epoch
                    let epoch = checkpoint["epoch"]!.item(Int32.self)
                    return Int(epoch)
                }
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Run Result", systemImage: "play.circle")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("Run", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                if isRunning {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            GroupBox {
                if output.isEmpty {
                    Text("Press the Run button to see results.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                } else {
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

            // Create Model
            result += "== Model Parameter Save/Load Demo ==\n\n"

            let model1 = Linear(4, 2)
            result += "1. Create Original Model\n"
            result += "Structure: Linear(4 -> 2)\n\n"

            // Check Original Parameters
            let originalParams = model1.parameters()
            eval(originalParams)
            result += "Original Parameters:\n"
            for (key, value) in originalParams.flattened() {
                result += "  \(key): shape=\(value.shape)\n"
            }

            // Check Output with Test Input
            let testInput = MLXArray.ones([1, 4])
            let originalOutput = model1(testInput)
            eval(originalOutput)
            result += "\nTest Output: \(originalOutput)\n\n"

            // Save to Temporary File
            let tempDir = FileManager.default.temporaryDirectory
            let savePath = tempDir.appendingPathComponent("test_model.safetensors")

            do {
                // Save - flattened() returns [(String, MLXArray)] so convert to dictionary
                let paramsDict = Dictionary(uniqueKeysWithValues: originalParams.flattened())
                try save(arrays: paramsDict, url: savePath)
                result += "2. Model Saved: \(savePath.lastPathComponent)\n\n"

                // Create New Model
                let model2 = Linear(4, 2)
                result += "3. Create New Model\n"

                // Check Before Loading Parameters
                let newOutput1 = model2(testInput)
                eval(newOutput1)
                result += "Output Before Load: \(newOutput1)\n"

                // Load Parameters
                let loadedParams = try loadArrays(url: savePath)
                model2.update(parameters: ModuleParameters.unflattened(loadedParams))
                result += "4. Parameters Loaded\n\n"

                // Check Output After Load
                let newOutput2 = model2(testInput)
                eval(newOutput2)
                result += "Output After Load: \(newOutput2)\n\n"

                // Compare
                let diff = abs(originalOutput - newOutput2).sum()
                eval(diff)
                result += "Difference from Original: \(diff)\n"
                result += "→ If difference is 0, parameters are exactly restored\n\n"

                // Cleanup
                try? FileManager.default.removeItem(at: savePath)

            } catch {
                result += "Error: \(error.localizedDescription)\n"
            }

            result += "== Supported Formats ==\n"
            result += "• .safetensors - Recommended (safe, fast)\n"
            result += "• .npz - NumPy compatible\n"
            result += "• .gguf - For LLM models"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter9View()
        .frame(width: 800, height: 700)
}
