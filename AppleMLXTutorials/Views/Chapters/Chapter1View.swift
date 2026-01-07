import SwiftUI
import MLX

/// Chapter 1: Introduction to MLX
struct Chapter1View: View {
    @State private var statusMessage: String = "Before test"
    @State private var statusColor: Color = .secondary
    @State private var isTesting = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 설명 섹션
                descriptionSection

                Divider()

                // 코드 예제 섹션
                codeSection

                Divider()

                // 실행 섹션
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
            **MLX** is an array framework designed for machine learning on Apple Silicon.
            Developed by Apple's machine learning research team, it provides a NumPy-like API.

            **Key Features:**
            • **Unified Memory Model** - CPU and GPU share memory, no data copying needed
            • **Lazy Evaluation** - Arrays are computed only when needed
            • **Automatic Differentiation** - Automatic gradient computation through function transforms
            • **Multi-device** - Flexible computation on CPU and GPU

            **MLX Swift Package Components:**
            • `MLX` - Core array framework
            • `MLXNN` - Neural network modules
            • `MLXOptimizers` - Optimization algorithms
            • `MLXRandom` - Random number generation

            **Supported Platforms:**
            • macOS 14.0+ (Apple Silicon)
            • iOS 17.0+ (Apple Silicon)
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Code Section

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Installation", systemImage: "chevron.left.forwardslash.chevron.right")
                .font(.title2.bold())

            Text("**Add to Package.swift:**")
                .font(.headline)

            CodeBlockView(code: """
                dependencies: [
                    .package(
                        url: "https://github.com/ml-explore/mlx-swift",
                        from: "0.21.2"
                    )
                ]

                // Add dependencies to target
                .target(
                    name: "YourApp",
                    dependencies: [
                        .product(name: "MLX", package: "mlx-swift"),
                        .product(name: "MLXNN", package: "mlx-swift"),
                        .product(name: "MLXOptimizers", package: "mlx-swift"),
                        .product(name: "MLXRandom", package: "mlx-swift"),
                    ]
                )
                """)

            Text("**Basic Usage:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // Create arrays
                let a = MLXArray([1, 2, 3, 4])
                let b = MLXArray([5, 6, 7, 8])

                // Array operations
                let sum = a + b
                let product = a * b

                // Check results (lazy evaluation executes here)
                print(sum)  // [6, 8, 10, 12]
                print(product)  // [5, 12, 21, 32]
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Run Test", systemImage: "play.circle")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: testMLX) {
                    Label("Test MLX", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isTesting)

                if isTesting {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            GroupBox {
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)

                    Text(statusMessage)
                        .font(.system(.body, design: .monospaced))

                    Spacer()
                }
                .padding()
            }
        }
    }

    // MARK: - Actions

    private func testMLX() {
        isTesting = true
        statusMessage = "Testing..."
        statusColor = .blue

        Task {
            do {
                // 기본 배열 테스트
                let a = MLXArray([1, 2, 3, 4])
                let b = MLXArray([5, 6, 7, 8])
                let sum = a + b

                // 결과 평가 (지연 계산 실행)
                eval(sum)

                // 디바이스 정보
                let device = Device.defaultDevice()

                await MainActor.run {
                    statusMessage = """
                    MLX test successful!

                    Array a: [1, 2, 3, 4]
                    Array b: [5, 6, 7, 8]
                    Sum: \(sum)

                    Device: \(device)
                    """
                    statusColor = .green
                    isTesting = false
                }
            }
        }
    }
}

#Preview {
    Chapter1View()
        .frame(width: 800, height: 600)
}
