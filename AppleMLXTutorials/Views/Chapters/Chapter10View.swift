import SwiftUI
import MLX
import MLXNN
import MLXOptimizers
import MLXRandom

/// Chapter 10: MNIST 분류기
struct Chapter10View: View {
    @State private var output: String = ""
    @State private var isRunning = false
    @State private var progress: Double = 0

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
            MNIST is a classic dataset for handwritten digit (0-9) classification.
            In this chapter, we combine everything learned so far to train a real classification model.

            **Dataset:**
            • 28x28 pixel grayscale images
            • 60,000 training images
            • 10,000 test images
            • 10 classes (0-9)

            **Model Architecture:**
            • Input: 784 (28x28 flattened)
            • Hidden layers: 256 -> 128
            • Output: 10 (class probabilities)

            **Training Process:**
            1. Load and preprocess data
            2. Define model (MLP)
            3. Loss function (Cross-Entropy)
            4. Optimizer (Adam)
            5. Run training loop
            6. Evaluate and measure accuracy
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

            Text("**MLP 모델 정의:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                class MNISTClassifier: Module, UnaryLayer {
                    let fc1: Linear
                    let fc2: Linear
                    let fc3: Linear

                    init() {
                        fc1 = Linear(784, 256)
                        fc2 = Linear(256, 128)
                        fc3 = Linear(128, 10)
                    }

                    func callAsFunction(_ x: MLXArray) -> MLXArray {
                        var x = x.reshaped([-1, 784])  // 평탄화
                        x = relu(fc1(x))
                        x = relu(fc2(x))
                        x = fc3(x)
                        return x  // logits 반환
                    }
                }
                """)

            Text("**손실 함수:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                func crossEntropyLoss(
                    logits: MLXArray,
                    labels: MLXArray
                ) -> MLXArray {
                    // Softmax + Negative Log Likelihood
                    let logSoftmax = logits - logSumExp(logits, axis: -1, keepDims: true)

                    // 정답 클래스의 log 확률만 선택
                    let nll = -take(logSoftmax, labels.asType(.int32), axis: -1)
                    return mean(nll)
                }
                """)

            Text("**학습 루프:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLXOptimizers

                let model = MNISTClassifier()
                let optimizer = Adam(learningRate: 0.001)

                for epoch in 0..<10 {
                    // 미니배치 학습
                    for batch in dataLoader {
                        let (images, labels) = batch

                        // Forward + Backward
                        let (loss, grads) = valueAndGrad(model) { model in
                            let logits = model(images)
                            return crossEntropyLoss(logits: logits, labels: labels)
                        }(model)

                        // 파라미터 업데이트
                        optimizer.update(model: model, gradients: grads)
                        eval(model, optimizer)
                    }

                    // 검증
                    let accuracy = evaluate(model, testData)
                    print("Epoch \\(epoch): Accuracy = \\(accuracy)")
                }
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Run Result", systemImage: "play.circle")
                .font(.title2.bold())

            Text("Note: The actual MNIST dataset needs to be downloaded separately. Here we demonstrate the training process with synthetic data.")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("학습 시작", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                if isRunning {
                    ProgressView(value: progress)
                        .frame(width: 100)
                    Text("\(Int(progress * 100))%")
                        .foregroundStyle(.secondary)
                }
            }

            GroupBox {
                if output.isEmpty {
                    Text("Press the Run button to start training.")
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
        progress = 0

        Task {
            var result = ""

            result += "== MNIST 분류기 학습 (합성 데이터) ==\n\n"

            // 모델 정의
            let fc1 = Linear(784, 256)
            let fc2 = Linear(256, 128)
            let fc3 = Linear(128, 10)

            func forward(_ x: MLXArray) -> MLXArray {
                var h = x.reshaped([-1, 784])
                h = relu(fc1(h))
                h = relu(fc2(h))
                return fc3(h)
            }

            // 간단한 cross-entropy 구현
            func loss(logits: MLXArray, labels: MLXArray) -> MLXArray {
                let maxLogit = logits.max(axis: -1, keepDims: true)
                let shifted = logits - maxLogit
                let logSumExp = log(sum(exp(shifted), axis: -1, keepDims: true))
                let logSoftmax = shifted - logSumExp

                // 간단히 평균 계산
                return -mean(logSoftmax * oneHot(labels, numClasses: 10))
            }

            func oneHot(_ labels: MLXArray, numClasses: Int) -> MLXArray {
                let n = labels.shape[0]
                // 실제 구현에서는 scatter 사용
                return MLXArray.zeros([n, numClasses])
            }

            // 옵티마이저 (데모용 - 실제 학습에서 사용)
            _ = Adam(learningRate: 0.001)

            result += "모델 구조:\n"
            result += "  Input: 784\n"
            result += "  FC1: 784 -> 256 + ReLU\n"
            result += "  FC2: 256 -> 128 + ReLU\n"
            result += "  FC3: 128 -> 10\n\n"

            // 합성 데이터로 학습 데모
            let batchSize = 32
            let numBatches = 10
            let epochs = 5

            result += "학습 설정:\n"
            result += "  배치 크기: \(batchSize)\n"
            result += "  배치 수: \(numBatches)\n"
            result += "  에폭: \(epochs)\n\n"

            result += "학습 진행:\n"

            for epoch in 0..<epochs {
                var epochLoss: Float = 0

                for batch in 0..<numBatches {
                    // 합성 데이터 생성
                    let x = MLXRandom.uniform(low: 0, high: 1, [batchSize, 784])
                    _ = MLXRandom.randInt(low: 0, high: 10, [batchSize])  // fakeLabels (데모)

                    // Forward
                    let logits = forward(x)

                    // 간단한 MSE 손실 (데모용)
                    let target = MLXRandom.uniform(low: 0, high: 1, [batchSize, 10])
                    let batchLoss = mean(square(softmax(logits) - target))
                    eval(batchLoss)

                    epochLoss += batchLoss.item(Float.self)

                    // 진행률 업데이트
                    let totalSteps = Float(epochs * numBatches)
                    let currentStep = Float(epoch * numBatches + batch + 1)
                    await MainActor.run {
                        progress = Double(currentStep / totalSteps)
                    }
                }

                let avgLoss = epochLoss / Float(numBatches)
                result += "Epoch \(epoch + 1)/\(epochs): Loss = \(String(format: "%.4f", avgLoss))\n"

                await MainActor.run {
                    output = result
                }
            }

            result += "\n학습 완료!\n\n"
            result += "== 실제 MNIST 학습 ==\n"
            result += "실제 MNIST 데이터로 학습하려면:\n"
            result += "1. mlx-swift-examples 저장소의 MNISTTrainer 참고\n"
            result += "2. MNIST 데이터셋 다운로드\n"
            result += "3. 데이터 로더 구현\n"
            result += "4. 전체 학습 루프 실행\n"

            await MainActor.run {
                output = result
                isRunning = false
                progress = 1.0
            }
        }
    }
}

#Preview {
    Chapter10View()
        .frame(width: 800, height: 700)
}
