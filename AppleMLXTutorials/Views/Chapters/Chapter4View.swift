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

                // 현재 기본 디바이스 확인
                let defaultDevice = Device.defaultDevice()
                print(defaultDevice)  // gpu 또는 cpu

                // 기본 디바이스 설정
                Device.setDefault(device: .gpu)

                // 특정 디바이스에서 배열 생성
                let gpuArray = MLXArray([1, 2, 3])  // 기본 디바이스(GPU)
                """)

            Text("**Streams and Synchronization:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // 기본 스트림 사용
                let a = MLXArray([1, 2, 3])
                let b = MLXArray([4, 5, 6])
                let c = a + b

                // 계산 실행 및 동기화
                eval(c)  // 지연된 계산을 실행

                // 여러 배열 동시 평가
                eval(a, b, c)
                """)

            Text("**Memory Management:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // 대용량 배열 생성
                let large = MLXArray.zeros([1000, 1000])

                // 계산 수행
                let result = large * 2

                // 명시적 평가로 메모리 할당
                eval(result)

                // 배열이 스코프를 벗어나면 자동 해제
                // Swift의 ARC가 메모리 관리
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

            // 디바이스 정보
            result += "== 디바이스 정보 ==\n"
            let defaultDevice = Device.defaultDevice()
            result += "기본 디바이스: \(defaultDevice)\n\n"

            // GPU 연산 테스트
            result += "== GPU 연산 테스트 ==\n"
            let size = 1000
            let a = MLXArray.ones([size, size])
            let b = MLXArray.ones([size, size])

            let startTime = CFAbsoluteTimeGetCurrent()
            let c = matmul(a, b)
            eval(c)
            let gpuTime = CFAbsoluteTimeGetCurrent() - startTime

            result += "행렬 크기: \(size) x \(size)\n"
            result += "행렬 곱셈 시간: \(String(format: "%.4f", gpuTime))초\n"
            result += "결과 shape: \(c.shape)\n"
            result += "결과 합계: \(c.sum())\n\n"

            // 메모리 효율성 데모
            result += "== 통합 메모리 데모 ==\n"
            result += "Apple Silicon 통합 메모리 아키텍처:\n"
            result += "• CPU와 GPU가 동일한 메모리 공유\n"
            result += "• 데이터 복사 오버헤드 없음\n"
            result += "• 시스템 전체 메모리를 ML에 활용 가능\n\n"

            // 지연 계산 데모
            result += "== 지연 계산 데모 ==\n"
            let x = MLXArray([1.0, 2.0, 3.0] as [Float])
            let y = x * 2
            let z = y + 1
            result += "x = \(x)\n"
            result += "y = x * 2 (아직 계산 안됨)\n"
            result += "z = y + 1 (아직 계산 안됨)\n"
            eval(z)  // 여기서 모든 계산이 한번에 실행
            result += "eval(z) 호출 후: \(z)\n"
            result += "→ 계산 그래프가 최적화되어 한번에 실행됨"

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
