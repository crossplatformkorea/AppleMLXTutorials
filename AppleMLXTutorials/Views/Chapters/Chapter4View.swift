import SwiftUI
import MLX

/// Chapter 4: Device Management
struct Chapter4View: View {
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
            One of MLX's greatest advantages is the **unified memory model**.
            Leveraging Apple Silicon's unified memory architecture, CPU and GPU share memory.

            **Key Concepts:**
            • **Unified Memory** - No data copying needed between CPU and GPU
            • **Device Selection** - Choose CPU or GPU per operation
            • **Automatic Device** - GPU prioritized by default

            **Supported Devices:**
            • `.cpu` - Run operations on CPU
            • `.gpu` - Run operations on GPU (Metal)

            **Benefits:**
            • Large models can utilize entire system memory
            • No data transfer overhead
            • Improved memory efficiency compared to PyTorch/TensorFlow
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

            Text("**Device Checking and Selection:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX

                // Check current default device
                let defaultDevice = Device.defaultDevice()
                print(defaultDevice)  // gpu or cpu

                // Set default device
                Device.setDefault(device: .gpu)

                // Create array on specific device
                let gpuArray = MLXArray([1, 2, 3])  // default device (GPU)
                """)

            Text("**Streams and Synchronization:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // Use default stream
                let a = MLXArray([1, 2, 3])
                let b = MLXArray([4, 5, 6])
                let c = a + b

                // Execute computation and synchronize
                eval(c)  // execute lazy computation

                // Evaluate multiple arrays at once
                eval(a, b, c)
                """)

            Text("**Memory Management:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // Create large array
                let large = MLXArray.zeros([1000, 1000])

                // Perform computation
                let result = large * 2

                // Allocate memory with explicit evaluation
                eval(result)

                // Automatically released when array goes out of scope
                // Swift's ARC manages memory
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

            // Device Info
            result += "== Device Info ==\n"
            let defaultDevice = Device.defaultDevice()
            result += "Default Device: \(defaultDevice)\n\n"

            // GPU Operation Test
            result += "== GPU Operation Test ==\n"
            let size = 1000
            let a = MLXArray.ones([size, size])
            let b = MLXArray.ones([size, size])

            let startTime = CFAbsoluteTimeGetCurrent()
            let c = matmul(a, b)
            eval(c)
            let gpuTime = CFAbsoluteTimeGetCurrent() - startTime

            result += "Matrix Size: \(size) x \(size)\n"
            result += "Matrix Multiplication Time: \(String(format: "%.4f", gpuTime))s\n"
            result += "Result shape: \(c.shape)\n"
            result += "Result sum: \(c.sum())\n\n"

            // Unified Memory Demo
            result += "== Unified Memory Demo ==\n"
            result += "Apple Silicon Unified Memory Architecture:\n"
            result += "• CPU and GPU share the same memory\n"
            result += "• No data copy overhead\n"
            result += "• Entire system memory available for ML\n\n"

            // Lazy Evaluation Demo
            result += "== Lazy Evaluation Demo ==\n"
            let x = MLXArray([1.0, 2.0, 3.0] as [Float])
            let y = x * 2
            let z = y + 1
            result += "x = \(x)\n"
            result += "y = x * 2 (not computed yet)\n"
            result += "z = y + 1 (not computed yet)\n"
            eval(z)  // All computations execute here at once
            result += "After eval(z): \(z)\n"
            result += "→ Computation graph optimized and executed at once"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter4View()
        .frame(width: 800, height: 700)
}
