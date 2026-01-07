import SwiftUI
import MLX

/// Chapter 5: 자동 미분
struct Chapter5View: View {
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
            **자동 미분(Automatic Differentiation)**은 딥러닝의 핵심입니다.
            MLX는 함수 변환을 통해 그래디언트를 자동으로 계산합니다.

            **핵심 개념:**
            • **grad** - 함수의 그래디언트(미분)를 계산하는 함수 반환
            • **valueAndGrad** - 함수값과 그래디언트를 동시에 반환
            • **역전파** - 출력에서 입력 방향으로 그래디언트 전파

            **사용 예시:**
            • 손실 함수의 그래디언트 계산
            • 신경망 가중치 업데이트
            • 최적화 알고리즘 구현

            **수학적 배경:**
            f(x) = x² 이면
            f'(x) = 2x

            MLX의 grad가 이를 자동으로 계산합니다.
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

            Text("**기본 그래디언트 계산:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX

                // f(x) = x^2 함수 정의
                func f(_ x: MLXArray) -> MLXArray {
                    return x * x  // 또는 square(x)
                }

                // 그래디언트 함수 생성
                let df = grad(f)

                // x = 3에서 그래디언트 계산
                let x = MLXArray(3.0)
                let gradient = df(x)  // 2 * 3 = 6
                print(gradient)  // 6.0
                """)

            Text("**값과 그래디언트 동시 계산:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                func loss(_ x: MLXArray) -> MLXArray {
                    return (x - 2) * (x - 2)  // (x-2)²
                }

                // 값과 그래디언트를 동시에 계산
                let lossAndGrad = valueAndGrad(loss)
                let x = MLXArray(5.0)
                let (value, grad) = lossAndGrad(x)

                print("f(5) = \\(value)")     // 9.0
                print("f'(5) = \\(grad)")    // 6.0 (= 2*(5-2))
                """)

            Text("**다변수 함수의 그래디언트:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // f(x, y) = x² + y²
                func f(_ params: [MLXArray]) -> MLXArray {
                    let x = params[0]
                    let y = params[1]
                    return x * x + y * y
                }

                // 모든 파라미터에 대한 그래디언트
                let gradF = grad(f)

                let params = [MLXArray(3.0), MLXArray(4.0)]
                let grads = gradF(params)
                // grads[0] = 6.0 (∂f/∂x = 2x)
                // grads[1] = 8.0 (∂f/∂y = 2y)
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

            // 1. 기본 그래디언트: f(x) = x²
            result += "== 기본 그래디언트 ==\n"
            result += "f(x) = x²\n"
            result += "f'(x) = 2x\n\n"

            // grad는 ([MLXArray]) -> [MLXArray] 시그니처를 사용
            let gradSquare = grad { arrays in
                let x = arrays[0]
                return [x * x]
            }

            for val in [1.0, 2.0, 3.0, 4.0, 5.0] {
                let x = MLXArray(Float(val))
                let grads = gradSquare([x])
                eval(grads)
                result += "f'(\(Int(val))) = \(grads[0])\n"
            }

            // 2. 값과 그래디언트 동시 계산
            result += "\n== 값과 그래디언트 동시 계산 ==\n"
            result += "f(x) = (x - 2)²\n"
            result += "f'(x) = 2(x - 2)\n\n"

            let lossAndGradFn = valueAndGrad { arrays in
                let x = arrays[0]
                let diff = x - 2
                return [diff * diff]
            }

            for val in [0.0, 1.0, 2.0, 3.0, 4.0] {
                let x = MLXArray(Float(val))
                let (values, grads) = lossAndGradFn([x])
                eval(values, grads)
                result += "x=\(Int(val)): f(x)=\(values[0]), f'(x)=\(grads[0])\n"
            }

            // 3. 간단한 경사하강법
            result += "\n== 간단한 경사하강법 ==\n"
            result += "목표: f(x) = (x-5)² 최소화\n"
            result += "시작점: x = 0\n"
            result += "학습률: 0.1\n\n"

            let gradObj = grad { arrays in
                let x = arrays[0]
                let diff = x - 5
                return [diff * diff]
            }

            var x = MLXArray(Float(0.0))
            let lr: Float = 0.1

            for step in 0..<10 {
                let grads = gradObj([x])
                eval(grads)
                x = x - lr * grads[0]
                eval(x)

                if step % 2 == 0 {
                    let diff = x - 5
                    let fx = diff * diff
                    eval(fx)
                    result += "Step \(step): x=\(String(format: "%.2f", x.item(Float.self))), f(x)=\(String(format: "%.4f", fx.item(Float.self)))\n"
                }
            }

            result += "\n최종 x ≈ 5.0 (최소점에 수렴)"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter5View()
        .frame(width: 800, height: 700)
}
