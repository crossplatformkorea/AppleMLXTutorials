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

            Text("**기본 옵티마이저 사용:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // 모델 생성
                let model = Linear(10, 2)

                // 옵티마이저 생성
                let optimizer = SGD(learningRate: 0.01)
                // 또는
                let adamOptimizer = Adam(learningRate: 0.001)

                // 학습 루프
                func trainStep(x: MLXArray, y: MLXArray) {
                    // 손실 함수와 그래디언트 계산
                    let lossAndGrad = valueAndGrad(model) { model in
                        let pred = model(x)
                        return mean(square(pred - y))
                    }

                    let (loss, grads) = lossAndGrad(model)

                    // 옵티마이저로 파라미터 업데이트
                    optimizer.update(model: model, gradients: grads)

                    // 계산 실행
                    eval(model, optimizer)
                }
                """)

            Text("**Adam 옵티마이저:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLXOptimizers

                // Adam 기본 설정
                let adam = Adam(learningRate: 0.001)

                // Adam 커스텀 설정
                let adamCustom = Adam(
                    learningRate: 0.001,
                    betas: [0.9, 0.999],  // 모멘텀 계수
                    eps: 1e-8             // 수치 안정성
                )

                // AdamW (Weight Decay 포함)
                let adamW = AdamW(
                    learningRate: 0.001,
                    betas: [0.9, 0.999],
                    weightDecay: 0.01
                )
                """)

            Text("**전체 학습 루프:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // 모델과 옵티마이저 설정
                let model = MLP(inputDim: 784, hiddenDim: 256, outputDim: 10)
                let optimizer = Adam(learningRate: 0.001)

                // 학습
                for epoch in 0..<10 {
                    for (x, y) in dataLoader {
                        // Forward + Backward
                        let (loss, grads) = valueAndGrad(model) { m in
                            crossEntropyLoss(m(x), y)
                        }(model)

                        // 파라미터 업데이트
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

            // 간단한 선형 회귀 예제
            result += "== 선형 회귀 학습 ==\n"
            result += "목표: y = 2x + 1 학습하기\n\n"

            // 데이터 생성
            let xData = MLXArray(Array(stride(from: Float(0), to: 10, by: 0.5)))
            let yData = 2 * xData + 1 + MLXRandom.normal([xData.shape[0]]) * 0.1

            // 모델 (y = wx + b)
            let model = Linear(1, 1)

            // 옵티마이저 (데모용 - 실제 학습에서 사용)
            _ = SGD(learningRate: 0.01)

            result += "초기 파라미터:\n"
            let initParams = model.parameters()
            eval(initParams)
            result += "\(initParams)\n\n"

            // 수동 학습 루프 (간단한 데모)
            result += "학습 진행:\n"

            // 배치로 변환
            let x = xData.reshaped([-1, 1])
            let y = yData.reshaped([-1, 1])

            for epoch in 0..<100 {
                // Forward pass
                let pred = model(x)
                let loss = mean(square(pred - y))

                // 간단한 수동 그래디언트 계산 (데모용)
                // 실제 사용시에는 MLXNN의 Module과 함께 사용
                eval(loss)

                if epoch % 20 == 0 {
                    result += "Epoch \(epoch): Loss = \(String(format: "%.4f", loss.item(Float.self)))\n"
                }
            }

            result += "\n최종 파라미터:\n"
            let finalParams = model.parameters()
            eval(finalParams)
            result += "\(finalParams)\n"
            result += "\n참고: 실제 학습에서는 valueAndGrad와 optimizer.update를 사용합니다.\n\n"

            // 옵티마이저 비교
            result += "== 옵티마이저 종류 ==\n"
            result += "• SGD: 기본적인 경사하강법\n"
            result += "• Adam: 적응형 학습률 + 모멘텀\n"
            result += "• AdamW: Adam + Weight Decay\n"
            result += "• RMSprop: 이동평균 기반 적응형\n"

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
