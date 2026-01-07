import SwiftUI
import MLX

/// Chapter 1: MLX 소개
struct Chapter1View: View {
    @State private var statusMessage: String = "테스트 전"
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
            Label("개요", systemImage: "info.circle")
                .font(.title2.bold())

            Text("""
            **MLX**는 Apple Silicon에서 머신러닝을 위해 설계된 배열 프레임워크입니다.
            Apple 머신러닝 연구팀에서 개발했으며, NumPy와 유사한 API를 제공합니다.

            **핵심 특징:**
            • **통합 메모리 모델** - CPU와 GPU가 메모리를 공유하여 데이터 복사 불필요
            • **지연 계산(Lazy Evaluation)** - 배열은 필요할 때만 계산됨
            • **자동 미분** - 함수 변환을 통한 그래디언트 자동 계산
            • **다중 디바이스** - CPU, GPU에서 유연하게 연산 실행

            **MLX Swift 패키지 구성:**
            • `MLX` - 핵심 배열 프레임워크
            • `MLXNN` - 신경망 모듈
            • `MLXOptimizers` - 최적화 알고리즘
            • `MLXRandom` - 난수 생성

            **지원 플랫폼:**
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
            Label("설치 방법", systemImage: "chevron.left.forwardslash.chevron.right")
                .font(.title2.bold())

            Text("**Package.swift에 추가:**")
                .font(.headline)

            CodeBlockView(code: """
                dependencies: [
                    .package(
                        url: "https://github.com/ml-explore/mlx-swift",
                        from: "0.21.2"
                    )
                ]

                // 타겟에 의존성 추가
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

            Text("**기본 사용법:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX

                // 배열 생성
                let a = MLXArray([1, 2, 3, 4])
                let b = MLXArray([5, 6, 7, 8])

                // 배열 연산
                let sum = a + b
                let product = a * b

                // 결과 확인 (지연 계산이 여기서 실행됨)
                print(sum)  // [6, 8, 10, 12]
                print(product)  // [5, 12, 21, 32]
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("실행 테스트", systemImage: "play.circle")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: testMLX) {
                    Label("MLX 테스트", systemImage: "play.fill")
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
        statusMessage = "테스트 중..."
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
                    MLX 테스트 성공!

                    배열 a: [1, 2, 3, 4]
                    배열 b: [5, 6, 7, 8]
                    합계: \(sum)

                    디바이스: \(device)
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
