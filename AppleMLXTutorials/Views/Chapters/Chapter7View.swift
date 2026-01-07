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

            Text("**활성화 함수:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0])

                // ReLU: max(0, x)
                let reluOut = relu(x)  // [0, 0, 0, 1, 2]

                // Leaky ReLU
                let leakyOut = leakyRelu(x)  // 음수에서 작은 기울기

                // GELU (Gaussian Error Linear Unit)
                let geluOut = gelu(x)

                // Sigmoid: 1 / (1 + e^-x)
                let sigmoidOut = sigmoid(x)  // (0, 1) 범위

                // Softmax: 확률 분포로 변환
                let logits = MLXArray([1.0, 2.0, 3.0])
                let probs = softmax(logits)  // 합이 1
                """)

            Text("**손실 함수:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // MSE Loss (회귀)
                let predictions = MLXArray([1.0, 2.0, 3.0])
                let targets = MLXArray([1.5, 2.0, 2.5])
                let mse = mean(square(predictions - targets))

                // Cross-Entropy Loss (분류)
                // logits: 모델 출력 [배치, 클래스]
                // labels: 정답 인덱스 [배치]
                func crossEntropyLoss(logits: MLXArray, labels: MLXArray) -> MLXArray {
                    let logProbs = logSoftmax(logits, axis: -1)
                    // labels를 one-hot으로 변환하여 계산
                    let loss = -mean(take(logProbs, labels, axis: -1))
                    return loss
                }

                // Binary Cross-Entropy (이진 분류)
                func binaryCrossEntropy(preds: MLXArray, targets: MLXArray) -> MLXArray {
                    let eps = MLXArray(1e-7)
                    let loss = -mean(
                        targets * log(preds + eps) +
                        (1 - targets) * log(1 - preds + eps)
                    )
                    return loss
                }
                """)

            Text("**손실 함수와 그래디언트:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // 손실 함수 정의
                func mseLoss(_ params: MLXArray, _ x: MLXArray, _ y: MLXArray) -> MLXArray {
                    let pred = params[0] * x + params[1]  // y = ax + b
                    return mean(square(pred - y))
                }

                // 그래디언트 계산
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

            // 활성화 함수 비교
            result += "== 활성화 함수 비교 ==\n"
            let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0] as [Float])
            result += "입력 x: \(x)\n\n"

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
            result += "합계: \(probs.sum())\n\n"

            // MSE Loss
            result += "== MSE Loss ==\n"
            let predictions = MLXArray([1.0, 2.0, 3.0, 4.0] as [Float])
            let targets = MLXArray([1.1, 2.2, 2.9, 3.8] as [Float])
            let mse = mean(square(predictions - targets))
            eval(mse)
            result += "예측: \(predictions)\n"
            result += "정답: \(targets)\n"
            result += "MSE: \(mse)\n\n"

            // Cross-Entropy 데모
            result += "== Cross-Entropy 개념 ==\n"
            let classLogits = MLXArray([2.0, 1.0, 0.1, 0.5, 2.5, 0.3] as [Float]).reshaped([2, 3])
            let classProbs = softmax(classLogits, axis: -1)
            eval(classProbs)
            result += "Logits:\n\(classLogits)\n"
            result += "확률 (softmax):\n\(classProbs)\n"
            result += "→ 각 행의 최대값이 예측 클래스"

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
