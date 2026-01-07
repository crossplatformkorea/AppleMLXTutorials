import SwiftUI
import MLX
import MLXNN

/// Chapter 7: 활성화 함수 & 손실 함수
struct Chapter7View: View {
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
            **Activation functions** and **loss functions** are core components of neural networks.

            **Activation Functions:**
            Add non-linearity to enable neural networks to learn complex patterns.
            • **ReLU** - max(0, x), most commonly used
            • **GELU** - Primarily used in Transformers
            • **SiLU/Swish** - x * sigmoid(x)
            • **Sigmoid** - Compresses output to 0~1
            • **Softmax** - Converts to probability distribution

            **Loss Functions:**
            Measure the difference between model predictions and actual values.
            • **MSE** - Regression problems
            • **Cross-Entropy** - Classification problems
            • **Binary Cross-Entropy** - Binary classification

            **Loss Function Selection Guide:**
            • Regression → MSE, MAE
            • Binary classification → Binary Cross-Entropy
            • Multi-class classification → Cross-Entropy (with Softmax)
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

            Text("**Activation Functions:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0])

                // ReLU: max(0, x)
                let reluOut = relu(x)  // [0, 0, 0, 1, 2]

                // Leaky ReLU
                let leakyOut = leakyRelu(x)  // small slope for negatives

                // GELU (Gaussian Error Linear Unit)
                let geluOut = gelu(x)

                // Sigmoid: 1 / (1 + e^-x)
                let sigmoidOut = sigmoid(x)  // range (0, 1)

                // Softmax: convert to probability distribution
                let logits = MLXArray([1.0, 2.0, 3.0])
                let probs = softmax(logits)  // sum equals 1
                """)

            Text("**Loss Functions:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // MSE Loss (regression)
                let predictions = MLXArray([1.0, 2.0, 3.0])
                let targets = MLXArray([1.5, 2.0, 2.5])
                let mse = mean(square(predictions - targets))

                // Cross-Entropy Loss (classification)
                // logits: model output [batch, classes]
                // labels: target indices [batch]
                func crossEntropyLoss(logits: MLXArray, labels: MLXArray) -> MLXArray {
                    let logProbs = logSoftmax(logits, axis: -1)
                    // Convert labels to one-hot for computation
                    let loss = -mean(take(logProbs, labels, axis: -1))
                    return loss
                }

                // Binary Cross-Entropy (binary classification)
                func binaryCrossEntropy(preds: MLXArray, targets: MLXArray) -> MLXArray {
                    let eps = MLXArray(1e-7)
                    let loss = -mean(
                        targets * log(preds + eps) +
                        (1 - targets) * log(1 - preds + eps)
                    )
                    return loss
                }
                """)

            Text("**Loss Functions and Gradients:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // Define loss function
                func mseLoss(_ params: MLXArray, _ x: MLXArray, _ y: MLXArray) -> MLXArray {
                    let pred = params[0] * x + params[1]  // y = ax + b
                    return mean(square(pred - y))
                }

                // Compute gradient
                let gradLoss = grad { params in
                    mseLoss(params, x, y)
                }

                let params = MLXArray([1.0, 0.0])  // a=1, b=0
                let grads = gradLoss(params)
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

            // Activation Function Comparison
            result += "== Activation Function Comparison ==\n"
            let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0] as [Float])
            result += "Input x: \(x)\n\n"

            let reluOut = relu(x)
            eval(reluOut)
            result += "ReLU(x):    \(reluOut)\n"

            let leakyOut = leakyRelu(x)
            eval(leakyOut)
            result += "LeakyReLU:  \(leakyOut)\n"

            let geluOut = gelu(x)
            eval(geluOut)
            result += "GELU(x):    \(geluOut)\n"

            let sigmoidOut = sigmoid(x)
            eval(sigmoidOut)
            result += "Sigmoid(x): \(sigmoidOut)\n"

            let tanhOut = tanh(x)
            eval(tanhOut)
            result += "Tanh(x):    \(tanhOut)\n\n"

            // Softmax
            result += "== Softmax ==\n"
            let logits = MLXArray([1.0, 2.0, 3.0, 4.0] as [Float])
            let probs = softmax(logits)
            eval(probs)
            result += "Logits: \(logits)\n"
            result += "Softmax: \(probs)\n"
            result += "Sum: \(probs.sum())\n\n"

            // MSE Loss
            result += "== MSE Loss ==\n"
            let predictions = MLXArray([1.0, 2.0, 3.0, 4.0] as [Float])
            let targets = MLXArray([1.1, 2.2, 2.9, 3.8] as [Float])
            let mse = mean(square(predictions - targets))
            eval(mse)
            result += "Predictions: \(predictions)\n"
            result += "Targets: \(targets)\n"
            result += "MSE: \(mse)\n\n"

            // Cross-Entropy Demo
            result += "== Cross-Entropy Concept ==\n"
            let classLogits = MLXArray([2.0, 1.0, 0.1, 0.5, 2.5, 0.3] as [Float]).reshaped([2, 3])
            let classProbs = softmax(classLogits, axis: -1)
            eval(classProbs)
            result += "Logits:\n\(classLogits)\n"
            result += "Probabilities (softmax):\n\(classProbs)\n"
            result += "→ Max value in each row is the predicted class"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter7View()
        .frame(width: 800, height: 700)
}
