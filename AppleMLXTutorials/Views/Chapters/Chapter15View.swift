import SwiftUI
import MLX

/// Chapter 15: 생태계 & 다음 단계
struct Chapter15View: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MLX 생태계
                ecosystemSection

                Divider()

                // 공식 리소스
                resourcesSection

                Divider()

                // 다음 단계
                nextStepsSection

                Divider()

                // 커뮤니티
                communitySection
            }
            .padding(24)
        }
    }

    // MARK: - Ecosystem Section

    private var ecosystemSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("MLX 생태계", systemImage: "network")
                .font(.title2.bold())

            Text("""
            MLX는 Apple Silicon에서 머신러닝을 위한 통합 프레임워크입니다.
            Python과 Swift API를 모두 지원하며, 활발하게 개발되고 있습니다.
            """)
            .font(.body)

            // 패키지 목록
            VStack(alignment: .leading, spacing: 12) {
                PackageCard(
                    name: "mlx",
                    description: "핵심 배열 프레임워크 (Python)",
                    url: "https://github.com/ml-explore/mlx"
                )

                PackageCard(
                    name: "mlx-swift",
                    description: "Swift API for MLX",
                    url: "https://github.com/ml-explore/mlx-swift"
                )

                PackageCard(
                    name: "mlx-swift-examples",
                    description: "LLM, VLM, MNIST, Stable Diffusion 예제",
                    url: "https://github.com/ml-explore/mlx-swift-examples"
                )

                PackageCard(
                    name: "mlx-lm (Python)",
                    description: "LLM 추론 및 파인튜닝",
                    url: "https://github.com/ml-explore/mlx-examples"
                )

                PackageCard(
                    name: "mlx-community",
                    description: "MLX 호환 모델 (Hugging Face)",
                    url: "https://huggingface.co/mlx-community"
                )
            }
        }
    }

    // MARK: - Resources Section

    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("공식 리소스", systemImage: "book")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 12) {
                ResourceLink(
                    title: "MLX Documentation",
                    description: "공식 문서 (Python & C++)",
                    icon: "doc.text",
                    url: "https://ml-explore.github.io/mlx/"
                )

                ResourceLink(
                    title: "Swift.org Blog",
                    description: "MLX Swift 소개 글",
                    icon: "swift",
                    url: "https://www.swift.org/blog/mlx-swift/"
                )

                ResourceLink(
                    title: "WWDC25 - MLX 시작하기",
                    description: "Apple 개발자 세션",
                    icon: "play.rectangle",
                    url: "https://developer.apple.com/videos/play/wwdc2025/315/"
                )

                ResourceLink(
                    title: "WWDC25 - LLM with MLX",
                    description: "대형 언어 모델 활용법",
                    icon: "play.rectangle",
                    url: "https://developer.apple.com/videos/play/wwdc2025/298/"
                )

                ResourceLink(
                    title: "Apple ML Research",
                    description: "MLX 연구 논문 및 블로그",
                    icon: "graduationcap",
                    url: "https://machinelearning.apple.com/"
                )
            }
        }
    }

    // MARK: - Next Steps Section

    private var nextStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("다음 단계", systemImage: "arrow.right.circle")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 16) {
                NextStepCard(
                    number: 1,
                    title: "예제 프로젝트 실행",
                    description: "mlx-swift-examples를 클론하고 LLMEval, MNISTTrainer 등을 직접 실행해보세요."
                )

                NextStepCard(
                    number: 2,
                    title: "나만의 모델 학습",
                    description: "간단한 분류기나 회귀 모델을 처음부터 만들어보세요. MNIST 예제를 커스터마이징하는 것도 좋습니다."
                )

                NextStepCard(
                    number: 3,
                    title: "LLM/VLM 앱 개발",
                    description: "로컬 LLM을 활용한 챗봇, 코드 어시스턴트, 이미지 분석 앱을 만들어보세요."
                )

                NextStepCard(
                    number: 4,
                    title: "모델 파인튜닝",
                    description: "LoRA를 사용해 특정 도메인이나 태스크에 맞게 모델을 조정해보세요."
                )

                NextStepCard(
                    number: 5,
                    title: "프로덕션 배포",
                    description: "최적화된 MLX 모델을 iOS/macOS 앱에 통합하고 App Store에 배포해보세요."
                )
            }
        }
    }

    // MARK: - Community Section

    private var communitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("커뮤니티", systemImage: "person.3")
                .font(.title2.bold())

            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Text("""
                    MLX는 오픈소스 프로젝트로, 커뮤니티의 기여를 환영합니다.
                    """)
                    .font(.body)

                    VStack(alignment: .leading, spacing: 8) {
                        CommunityLink(
                            title: "GitHub Issues",
                            description: "버그 리포트 및 기능 요청",
                            icon: "ant",
                            url: "https://github.com/ml-explore/mlx/issues"
                        )

                        CommunityLink(
                            title: "GitHub Discussions",
                            description: "질문 및 토론",
                            icon: "bubble.left.and.bubble.right",
                            url: "https://github.com/ml-explore/mlx/discussions"
                        )

                        CommunityLink(
                            title: "Hugging Face mlx-community",
                            description: "MLX 호환 모델 공유",
                            icon: "face.smiling",
                            url: "https://huggingface.co/mlx-community"
                        )
                    }

                    Divider()

                    Text("이 튜토리얼은 크로스플랫폼 코리아에서 제작했습니다.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Link(destination: URL(string: "https://www.youtube.com/@crossplatformkorea")!) {
                        Label("크로스플랫폼 코리아 YouTube", systemImage: "play.rectangle")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
}

// MARK: - Helper Views

struct PackageCard: View {
    let name: String
    let description: String
    let url: String

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Link(destination: URL(string: url)!) {
                    Image(systemName: "arrow.up.right.square")
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
    }
}

struct ResourceLink: View {
    let title: String
    let description: String
    let icon: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.tint)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

struct NextStepCard: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(.tint))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct CommunityLink: View {
    let title: String
    let description: String
    let icon: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.tint)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.subheadline.bold())
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Chapter15View()
        .frame(width: 800, height: 800)
}
