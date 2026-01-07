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
            Label("개요", systemImage: "info.circle")
                .font(.title2.bold())

            Text("""
            **활성화 함수**와 **손실 함수**는 신경망의 핵심 구성 요소입니다.

            **활성화 함수:**
            비선형성을 추가하여 신경망이 복잡한 패턴을 학습할 수 있게 합니다.
            • **ReLU** - max(0, x), 가장 많이 사용
            • **GELU** - Transformer에서 주로 사용
            • **SiLU/Swish** - x * sigmoid(x)
            • **Sigmoid** - 출력을 0~1로 압축
            • **Softmax** - 확률 분포로 변환

            **손실 함수:**
            모델의 예측과 실제값의 차이를 측정합니다.
            • **MSE** - 회귀 문제
            • **Cross-Entropy** - 분류 문제
            • **Binary Cross-Entropy** - 이진 분류

            **손실 함수 선택 가이드:**
            • 회귀 → MSE, MAE
            • 이진 분류 → Binary Cross-Entropy
            • 다중 분류 → Cross-Entropy (with Softmax)
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Code Section

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("코드 예제", systemImage: "chevron.left.forwardslash.chevron.right")
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
            Label("실행 결과", systemImage: "play.circle")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("실행", systemImage: "play.fill")
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
                    Text("실행 버튼을 눌러 결과를 확인하세요.")
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
            let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0])
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
            let logits = MLXArray([1.0, 2.0, 3.0, 4.0])
            let probs = softmax(logits)
            eval(probs)
            result += "Logits: \(logits)\n"
            result += "Softmax: \(probs)\n"
            result += "합계: \(probs.sum())\n\n"

            // MSE Loss
            result += "== MSE Loss ==\n"
            let predictions = MLXArray([1.0, 2.0, 3.0, 4.0])
            let targets = MLXArray([1.1, 2.2, 2.9, 3.8])
            let mse = mean(square(predictions - targets))
            eval(mse)
            result += "예측: \(predictions)\n"
            result += "정답: \(targets)\n"
            result += "MSE: \(mse)\n\n"

            // Cross-Entropy 데모
            result += "== Cross-Entropy 개념 ==\n"
            let classLogits = MLXArray([2.0, 1.0, 0.1, 0.5, 2.5, 0.3]).reshaped([2, 3])
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
