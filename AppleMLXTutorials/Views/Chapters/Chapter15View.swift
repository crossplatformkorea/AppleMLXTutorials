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
            Label("MLX Ecosystem", systemImage: "network")
                .font(.title2.bold())

            Text("""
            MLX is a unified framework for machine learning on Apple Silicon.
            It supports both Python and Swift APIs and is actively developed.
            """)
            .font(.body)

            // 패키지 목록
            VStack(alignment: .leading, spacing: 12) {
                PackageCard(
                    name: "mlx",
                    description: "Core array framework (Python)",
                    url: "https://github.com/ml-explore/mlx"
                )

                PackageCard(
                    name: "mlx-swift",
                    description: "Swift API for MLX",
                    url: "https://github.com/ml-explore/mlx-swift"
                )

                PackageCard(
                    name: "mlx-swift-examples",
                    description: "LLM, VLM, MNIST, Stable Diffusion examples",
                    url: "https://github.com/ml-explore/mlx-swift-examples"
                )

                PackageCard(
                    name: "mlx-lm (Python)",
                    description: "LLM inference and fine-tuning",
                    url: "https://github.com/ml-explore/mlx-examples"
                )

                PackageCard(
                    name: "mlx-community",
                    description: "MLX compatible models (Hugging Face)",
                    url: "https://huggingface.co/mlx-community"
                )
            }
        }
    }

    // MARK: - Resources Section

    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Official Resources", systemImage: "book")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 12) {
                ResourceLink(
                    title: "MLX Documentation",
                    description: "Official documentation (Python & C++)",
                    icon: "doc.text",
                    url: "https://ml-explore.github.io/mlx/"
                )

                ResourceLink(
                    title: "Swift.org Blog",
                    description: "MLX Swift introduction article",
                    icon: "swift",
                    url: "https://www.swift.org/blog/mlx-swift/"
                )

                ResourceLink(
                    title: "WWDC25 - Getting Started with MLX",
                    description: "Apple Developer session",
                    icon: "play.rectangle",
                    url: "https://developer.apple.com/videos/play/wwdc2025/315/"
                )

                ResourceLink(
                    title: "WWDC25 - LLM with MLX",
                    description: "How to use large language models",
                    icon: "play.rectangle",
                    url: "https://developer.apple.com/videos/play/wwdc2025/298/"
                )

                ResourceLink(
                    title: "Apple ML Research",
                    description: "MLX research papers and blog",
                    icon: "graduationcap",
                    url: "https://machinelearning.apple.com/"
                )
            }
        }
    }

    // MARK: - Next Steps Section

    private var nextStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Next Steps", systemImage: "arrow.right.circle")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 16) {
                NextStepCard(
                    number: 1,
                    title: "Run Example Projects",
                    description: "Clone mlx-swift-examples and run LLMEval, MNISTTrainer, and more."
                )

                NextStepCard(
                    number: 2,
                    title: "Train Your Own Model",
                    description: "Build a simple classifier or regression model from scratch. Customizing the MNIST example is a good start."
                )

                NextStepCard(
                    number: 3,
                    title: "Develop LLM/VLM Apps",
                    description: "Create chatbots, code assistants, and image analysis apps using local LLMs."
                )

                NextStepCard(
                    number: 4,
                    title: "Fine-tune Models",
                    description: "Use LoRA to adapt models for specific domains or tasks."
                )

                NextStepCard(
                    number: 5,
                    title: "Production Deployment",
                    description: "Integrate optimized MLX models into iOS/macOS apps and deploy to the App Store."
                )
            }
        }
    }

    // MARK: - Community Section

    private var communitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Community", systemImage: "person.3")
                .font(.title2.bold())

            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Text("""
                    MLX is an open-source project and welcomes community contributions.
                    """)
                    .font(.body)

                    VStack(alignment: .leading, spacing: 8) {
                        CommunityLink(
                            title: "GitHub Issues",
                            description: "Bug reports and feature requests",
                            icon: "ant",
                            url: "https://github.com/ml-explore/mlx/issues"
                        )

                        CommunityLink(
                            title: "GitHub Discussions",
                            description: "Questions and discussions",
                            icon: "bubble.left.and.bubble.right",
                            url: "https://github.com/ml-explore/mlx/discussions"
                        )

                        CommunityLink(
                            title: "Hugging Face mlx-community",
                            description: "Share MLX compatible models",
                            icon: "face.smiling",
                            url: "https://huggingface.co/mlx-community"
                        )
                    }

                    Divider()

                    Text("This tutorial was created by Cross Platform Korea.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Link(destination: URL(string: "https://www.youtube.com/@crossplatformkorea")!) {
                        Label("Cross Platform Korea YouTube", systemImage: "play.rectangle")
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
