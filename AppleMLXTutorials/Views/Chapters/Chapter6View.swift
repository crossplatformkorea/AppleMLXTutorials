import SwiftUI
import MLX
import MLXNN

/// Chapter 6: 신경망 기초 (MLXNN)
struct Chapter6View: View {
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
            **MLXNN** provides high-level modules for building neural networks.
            It has an API similar to PyTorch's torch.nn.

            **Core Components:**
            • **Module** - Base class for all neural network layers
            • **Linear** - Fully connected layer
            • **Embedding** - Embedding layer
            • **Conv2d** - 2D convolution layer

            **Module Protocol:**
            • `callAsFunction(_:)` - Performs forward pass
            • `parameters()` - Returns trainable parameters
            • `update(parameters:)` - Updates parameters

            **Layer Types:**
            • Linear layers: Linear
            • Activations: ReLU, GELU, SiLU, Sigmoid
            • Normalization: LayerNorm, RMSNorm, BatchNorm
            • Attention: MultiHeadAttention
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

            Text("**Linear 레이어:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // Linear 레이어 생성 (입력 4, 출력 2)
                let linear = Linear(4, 2)

                // 순전파
                let input = MLXArray.ones([1, 4])  // 배치 1, 피처 4
                let output = linear(input)        // [1, 2]

                // 파라미터 확인
                let params = linear.parameters()
                print(params)
                """)

            Text("**간단한 MLP 모델:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // MLP 모델 정의
                class MLP: Module, UnaryLayer {
                    let fc1: Linear
                    let fc2: Linear
                    let fc3: Linear

                    init(inputDim: Int, hiddenDim: Int, outputDim: Int) {
                        fc1 = Linear(inputDim, hiddenDim)
                        fc2 = Linear(hiddenDim, hiddenDim)
                        fc3 = Linear(hiddenDim, outputDim)
                    }

                    func callAsFunction(_ x: MLXArray) -> MLXArray {
                        var x = fc1(x)
                        x = relu(x)
                        x = fc2(x)
                        x = relu(x)
                        x = fc3(x)
                        return x
                    }
                }

                // 모델 생성
                let model = MLP(inputDim: 784, hiddenDim: 256, outputDim: 10)

                // 입력 데이터
                let x = MLXRandom.normal([32, 784])  // 배치 32

                // 순전파
                let output = model(x)  // [32, 10]
                """)

            Text("**Embedding 레이어:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // 임베딩 레이어: vocab 1000, dim 128
                let embedding = Embedding(embeddingCount: 1000, dimensions: 128)

                // 토큰 인덱스
                let tokens = MLXArray([1, 5, 10, 20])

                // 임베딩 조회
                let embedded = embedding(tokens)  // [4, 128]
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

            // 1. Linear 레이어
            result += "== Linear 레이어 ==\n"
            let linear = Linear(4, 2)
            let input = MLXArray.ones([2, 4])  // 배치 2, 피처 4
            let linearOutput = linear(input)
            eval(linearOutput)

            result += "입력 shape: \(input.shape)\n"
            result += "Linear(4 -> 2)\n"
            result += "출력 shape: \(linearOutput.shape)\n"
            result += "출력:\n\(linearOutput)\n\n"

            // 2. 활성화 함수
            result += "== 활성화 함수 ==\n"
            let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0] as [Float])
            result += "입력: \(x)\n"
            result += "ReLU: \(relu(x))\n"
            result += "Sigmoid: \(sigmoid(x))\n"
            result += "Tanh: \(tanh(x))\n\n"

            // 3. 간단한 MLP
            result += "== 간단한 MLP ==\n"

            // Sequential 대신 직접 레이어 조합
            let fc1 = Linear(4, 8)
            let fc2 = Linear(8, 2)

            let mlpInput = MLXRandom.uniform(low: 0, high: 1, [3, 4])
            var h = fc1(mlpInput)
            h = relu(h)
            let mlpOutput = fc2(h)
            eval(mlpOutput)

            result += "MLP 구조: 4 -> 8 -> 2\n"
            result += "입력 shape: \(mlpInput.shape)\n"
            result += "출력 shape: \(mlpOutput.shape)\n"
            result += "출력:\n\(mlpOutput)\n\n"

            // 4. Embedding
            result += "== Embedding ==\n"
            let embedding = Embedding(embeddingCount: 100, dimensions: 16)
            let tokens = MLXArray([0, 5, 10, 15])
            let embedded = embedding(tokens)
            eval(embedded)

            result += "Vocab size: 100, Embedding dim: 16\n"
            result += "토큰: \(tokens)\n"
            result += "임베딩 shape: \(embedded.shape)\n"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter6View()
        .frame(width: 800, height: 700)
}
