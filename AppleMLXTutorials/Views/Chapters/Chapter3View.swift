import SwiftUI
import MLX

/// Chapter 3: 배열 연산
struct Chapter3View: View {
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
            MLX는 NumPy와 유사한 풍부한 배열 연산을 제공합니다.

            **산술 연산:**
            • 덧셈, 뺄셈, 곱셈, 나눗셈
            • 요소별(element-wise) 연산
            • 브로드캐스팅 지원

            **수학 함수:**
            • `exp`, `log`, `sqrt`, `abs`
            • `sin`, `cos`, `tan`
            • `power`, `square`

            **집계(Reduce) 연산:**
            • `sum`, `mean`, `prod`
            • `min`, `max`
            • `argMax`, `argMin`

            **형태 변환:**
            • `reshape` - 형태 변경
            • `transpose` - 전치
            • `flatten` - 1차원으로 펼치기
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

            Text("**산술 연산:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX

                let a = MLXArray([1.0, 2.0, 3.0, 4.0])
                let b = MLXArray([2.0, 2.0, 2.0, 2.0])

                // 기본 연산
                let sum = a + b          // [3, 4, 5, 6]
                let diff = a - b         // [-1, 0, 1, 2]
                let prod = a * b         // [2, 4, 6, 8]
                let quot = a / b         // [0.5, 1, 1.5, 2]

                // 스칼라 연산
                let scaled = a * 2       // [2, 4, 6, 8]
                let shifted = a + 10     // [11, 12, 13, 14]
                """)

            Text("**수학 함수:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                let x = MLXArray([1.0, 4.0, 9.0, 16.0])

                let sqrtX = sqrt(x)      // [1, 2, 3, 4]
                let expX = exp(x)        // e^x
                let logX = log(x)        // ln(x)
                let absX = abs(x)        // 절대값

                // 삼각함수
                let angles = MLXArray([0.0, Float.pi/2, Float.pi])
                let sinX = sin(angles)   // [0, 1, 0]
                """)

            Text("**집계 연산:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                let arr = MLXArray([[1, 2, 3], [4, 5, 6]])

                // 전체 집계
                let total = arr.sum()           // 21
                let average = arr.mean()        // 3.5

                // 축(axis)별 집계
                let colSum = arr.sum(axis: 0)   // [5, 7, 9]
                let rowSum = arr.sum(axis: 1)   // [6, 15]

                // 최대/최소
                let maxVal = arr.max()          // 6
                let argMax = arr.argMax()       // 최대값 인덱스
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

            // 산술 연산
            let a = MLXArray([1.0, 2.0, 3.0, 4.0])
            let b = MLXArray([2.0, 2.0, 2.0, 2.0])

            result += "== 산술 연산 ==\n"
            result += "a = \(a)\n"
            result += "b = \(b)\n"
            result += "a + b = \(a + b)\n"
            result += "a * b = \(a * b)\n"
            result += "a / b = \(a / b)\n"
            result += "a * 3 = \(a * 3)\n\n"

            // 수학 함수
            result += "== 수학 함수 ==\n"
            let x = MLXArray([1.0, 4.0, 9.0, 16.0])
            result += "x = \(x)\n"
            result += "sqrt(x) = \(sqrt(x))\n"
            result += "log(x) = \(log(x))\n"
            result += "square(x) = \(square(x))\n\n"

            // 집계 연산
            result += "== 집계 연산 ==\n"
            let matrix = MLXArray([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]).reshaped([2, 3])
            result += "matrix:\n\(matrix)\n"
            result += "sum() = \(matrix.sum())\n"
            result += "mean() = \(matrix.mean())\n"
            result += "max() = \(matrix.max())\n"
            result += "min() = \(matrix.min())\n"
            result += "sum(axis: 0) = \(matrix.sum(axis: 0))\n"
            result += "sum(axis: 1) = \(matrix.sum(axis: 1))\n\n"

            // 형태 변환
            result += "== 형태 변환 ==\n"
            let flat = matrix.flattened()
            result += "flatten: \(flat)\n"
            let reshaped = flat.reshaped([3, 2])
            result += "reshape [3, 2]:\n\(reshaped)\n"
            result += "transpose:\n\(matrix.transposed())"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter3View()
        .frame(width: 800, height: 700)
}
