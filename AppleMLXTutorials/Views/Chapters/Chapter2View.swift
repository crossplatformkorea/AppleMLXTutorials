import SwiftUI
import MLX

/// Chapter 2: 배열 기초
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
            Label("개요", systemImage: "info.circle")
                .font(.title2.bold())

            Text("""
            `MLXArray`는 MLX의 핵심 데이터 구조입니다.
            NumPy의 ndarray와 유사하게 다차원 배열을 표현합니다.

            **주요 특징:**
            • 다양한 데이터 타입 지원 (Float32, Int32, Bool 등)
            • 다차원 배열 (스칼라, 벡터, 행렬, 텐서)
            • 지연 계산 - `eval()` 호출 시 실제 계산 수행
            • 브로드캐스팅 지원

            **데이터 타입:**
            • `.float32`, `.float16`, `.bfloat16` - 부동소수점
            • `.int32`, `.int64`, `.uint32` - 정수
            • `.bool` - 불리언
            • `.complex64` - 복소수
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

            Text("**배열 생성 방법:**")
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

            Text("**배열 속성:**")
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

            // 1. 기본 배열 생성
            let a = MLXArray([1.0, 2.0, 3.0, 4.0])
            result += "1D 배열: \(a)\n"

            // 2. 2D 배열 (행렬)
            let matrix = MLXArray([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]).reshaped([2, 3])
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
            let floats = MLXArray([1.0, 2.0, 3.0])
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
