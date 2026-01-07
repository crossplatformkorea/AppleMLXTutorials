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

                // 1. Create from Swift arrays
                let a = MLXArray([1, 2, 3, 4])
                let b = MLXArray([1.0, 2.0, 3.0])

                // 2. 2D array (matrix)
                let matrix = MLXArray([
                    [1, 2, 3],
                    [4, 5, 6]
                ])

                // 3. Create special arrays
                let zeros = MLXArray.zeros([3, 3])           // 3x3 zero matrix
                let ones = MLXArray.ones([2, 4])             // 2x4 ones matrix
                let identity = MLXArray.identity(3)          // 3x3 identity matrix
                let range = MLXArray(0 ..< 10)               // [0, 1, ..., 9]

                // 4. Specify data type
                let floats = MLXArray([1, 2, 3], dtype: .float32)
                let ints = MLXArray([1.5, 2.5], dtype: .int32)  // [1, 2]
                """)

            Text("**Array Properties:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                let arr = MLXArray([[1, 2, 3], [4, 5, 6]])

                arr.shape       // [2, 3] - shape
                arr.ndim        // 2 - number of dimensions
                arr.size        // 6 - total element count
                arr.dtype       // .int32 - data type
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

            // 1. Basic Array Creation
            let a = MLXArray([1.0, 2.0, 3.0, 4.0] as [Float])
            result += "1D Array: \(a)\n"

            // 2. 2D Array (Matrix)
            let matrix = MLXArray([1.0, 2.0, 3.0, 4.0, 5.0, 6.0] as [Float]).reshaped([2, 3])
            result += "2D Matrix:\n\(matrix)\n"
            result += "  shape: \(matrix.shape)\n"
            result += "  ndim: \(matrix.ndim)\n"
            result += "  size: \(matrix.size)\n"
            result += "  dtype: \(matrix.dtype)\n\n"

            // 3. Special Arrays
            let zeros = MLXArray.zeros([2, 3])
            result += "Zeros (2x3):\n\(zeros)\n\n"

            let ones = MLXArray.ones([2, 2])
            result += "Ones (2x2):\n\(ones)\n\n"

            let identity = MLXArray.identity(3)
            result += "Identity (3x3):\n\(identity)\n\n"

            // 4. Range Array
            let range = MLXArray(Array(0..<5).map { Float($0) })
            result += "Range [0, 5): \(range)\n\n"

            // 5. Data Type Conversion
            let floats = MLXArray([1.0, 2.0, 3.0] as [Float])
            result += "Float32 Array: \(floats)\n"
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
