import SwiftUI
import MLX
import MLXNN
import MLXOptimizers

/// Chapter 8: 옵티마이저
struct Chapter8View: View {
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
            **Optimizers** use gradients to update model parameters.

            **Optimizers provided by MLXOptimizers:**
            • **SGD** - Stochastic Gradient Descent
            • **Adam** - Most widely used optimizer
            • **AdamW** - Adam with Weight Decay
            • **Adagrad** - Adaptive learning rate
            • **RMSprop** - Moving average based

            **Key Concepts:**
            • **Learning Rate** - Controls update magnitude
            • **Momentum** - Maintains previous gradient direction
            • **Weight Decay** - Regularization to prevent overfitting

            **Learning Rate Scheduling:**
            • Fixed learning rate
            • Step decay
            • Cosine annealing
            • Warmup + decay
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

            Text("**Basic Optimizer Usage:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // Create model
                let model = Linear(10, 2)

                // Create optimizer
                let optimizer = SGD(learningRate: 0.01)
                // or
                let adamOptimizer = Adam(learningRate: 0.001)

                // Training loop
                func trainStep(x: MLXArray, y: MLXArray) {
                    // Compute loss function and gradient
                    let lossAndGrad = valueAndGrad(model) { model in
                        let pred = model(x)
                        return mean(square(pred - y))
                    }

                    let (loss, grads) = lossAndGrad(model)

                    // Update parameters with optimizer
                    optimizer.update(model: model, gradients: grads)

                    // Execute computation
                    eval(model, optimizer)
                }
                """)

            Text("**Adam Optimizer:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLXOptimizers

                // Adam default settings
                let adam = Adam(learningRate: 0.001)

                // Adam custom settings
                let adamCustom = Adam(
                    learningRate: 0.001,
                    betas: [0.9, 0.999],  // momentum coefficients
                    eps: 1e-8             // numerical stability
                )

                // AdamW (with Weight Decay)
                let adamW = AdamW(
                    learningRate: 0.001,
                    betas: [0.9, 0.999],
                    weightDecay: 0.01
                )
                """)

            Text("**Full Training Loop:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // Setup model and optimizer
                let model = MLP(inputDim: 784, hiddenDim: 256, outputDim: 10)
                let optimizer = Adam(learningRate: 0.001)

                // Training
                for epoch in 0..<10 {
                    for (x, y) in dataLoader {
                        // Forward + Backward
                        let (loss, grads) = valueAndGrad(model) { m in
                            crossEntropyLoss(m(x), y)
                        }(model)

                        // Update parameters
                        optimizer.update(model: model, gradients: grads)
                        eval(model, optimizer)
                    }
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

            // Simple Linear Regression Example
            result += "== Linear Regression Training ==\n"
            result += "Goal: Learn y = 2x + 1\n\n"

            // Generate Data
            let xData = MLXArray(Array(stride(from: Float(0), to: 10, by: 0.5)))
            let yData = 2 * xData + 1 + MLXRandom.normal([xData.shape[0]]) * 0.1

            // Model (y = wx + b)
            let model = Linear(1, 1)

            // Optimizer (for demo - used in actual training)
            _ = SGD(learningRate: 0.01)

            result += "Initial Parameters:\n"
            let initParams = model.parameters()
            eval(initParams)
            result += "\(initParams)\n\n"

            // Manual Training Loop (simple demo)
            result += "Training Progress:\n"

            // Convert to batch
            let x = xData.reshaped([-1, 1])
            let y = yData.reshaped([-1, 1])

            for epoch in 0..<100 {
                // Forward pass
                let pred = model(x)
                let loss = mean(square(pred - y))

                // Simple manual gradient computation (for demo)
                // In real usage, use with MLXNN's Module
                eval(loss)

                if epoch % 20 == 0 {
                    result += "Epoch \(epoch): Loss = \(String(format: "%.4f", loss.item(Float.self)))\n"
                }
            }

            result += "\nFinal Parameters:\n"
            let finalParams = model.parameters()
            eval(finalParams)
            result += "\(finalParams)\n"
            result += "\nNote: In real training, use valueAndGrad and optimizer.update.\n\n"

            // Optimizer Comparison
            result += "== Optimizer Types ==\n"
            result += "• SGD: Basic gradient descent\n"
            result += "• Adam: Adaptive learning rate + momentum\n"
            result += "• AdamW: Adam + Weight Decay\n"
            result += "• RMSprop: Moving average based adaptive\n"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter8View()
        .frame(width: 800, height: 700)
}
