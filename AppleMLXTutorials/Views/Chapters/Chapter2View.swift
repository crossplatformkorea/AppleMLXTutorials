import SwiftUI
import MLX

/// Chapter 2: Array Basics
struct Chapter2View: View {
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
            `MLXArray` is the core data structure of MLX.
            Similar to NumPy's ndarray, it represents multi-dimensional arrays.

            **Key Features:**
            • Support for various data types (Float32, Int32, Bool, etc.)
            • Multi-dimensional arrays (scalars, vectors, matrices, tensors)
            • Lazy evaluation - actual computation performed when `eval()` is called
            • Broadcasting support

            **Data Types:**
            • `.float32`, `.float16`, `.bfloat16` - Floating point
            • `.int32`, `.int64`, `.uint32` - Integers
            • `.bool` - Boolean
            • `.complex64` - Complex numbers
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

            Text("**Array Creation Methods:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX

                // 1. Swift 배열에서 생성
                let a = MLXArray([1, 2, 3, 4])
                let b = MLXArray([1.0, 2.0, 3.0])

                // 2. 2차원 배열 (행렬)
                let matrix = MLXArray([
                    [1, 2, 3],
                    [4, 5, 6]
                ])

                // 3. 특수 배열 생성
                let zeros = MLXArray.zeros([3, 3])           // 3x3 영행렬
                let ones = MLXArray.ones([2, 4])             // 2x4 일행렬
                let identity = MLXArray.identity(3)          // 3x3 단위행렬
                let range = MLXArray(0 ..< 10)               // [0, 1, ..., 9]

                // 4. 데이터 타입 지정
                let floats = MLXArray([1, 2, 3], dtype: .float32)
                let ints = MLXArray([1.5, 2.5], dtype: .int32)  // [1, 2]
                """)

            Text("**Array Properties:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                let arr = MLXArray([[1, 2, 3], [4, 5, 6]])

                arr.shape       // [2, 3] - 형태
                arr.ndim        // 2 - 차원 수
                arr.size        // 6 - 전체 요소 수
                arr.dtype       // .int32 - 데이터 타입
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

            // 1. 기본 배열 생성
            let a = MLXArray([1.0, 2.0, 3.0, 4.0] as [Float])
            result += "1D 배열: \(a)\n"

            // 2. 2D 배열 (행렬)
            let matrix = MLXArray([1.0, 2.0, 3.0, 4.0, 5.0, 6.0] as [Float]).reshaped([2, 3])
            result += "2D 행렬:\n\(matrix)\n"
            result += "  shape: \(matrix.shape)\n"
            result += "  ndim: \(matrix.ndim)\n"
            result += "  size: \(matrix.size)\n"
            result += "  dtype: \(matrix.dtype)\n\n"

            // 3. 특수 배열
            let zeros = MLXArray.zeros([2, 3])
            result += "Zeros (2x3):\n\(zeros)\n\n"

            let ones = MLXArray.ones([2, 2])
            result += "Ones (2x2):\n\(ones)\n\n"

            let identity = MLXArray.identity(3)
            result += "Identity (3x3):\n\(identity)\n\n"

            // 4. 범위 배열
            let range = MLXArray(Array(0..<5).map { Float($0) })
            result += "Range [0, 5): \(range)\n\n"

            // 5. 데이터 타입 변환
            let floats = MLXArray([1.0, 2.0, 3.0] as [Float])
            result += "Float32 배열: \(floats)\n"
            result += "dtype: \(floats.dtype)"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter2View()
        .frame(width: 800, height: 700)
}
