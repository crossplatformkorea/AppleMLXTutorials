import Foundation

/// 튜토리얼 챕터를 나타내는 모델
struct Chapter: Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let description: String

    static let allChapters: [Chapter] = [
        Chapter(
            id: 1,
            title: "MLX 소개",
            subtitle: "Introduction",
            icon: "sparkles",
            description: "MLX 프레임워크 소개와 Apple Silicon에서의 머신러닝을 알아봅니다."
        ),
        Chapter(
            id: 2,
            title: "배열 기초",
            subtitle: "MLXArray Basics",
            icon: "square.grid.3x3",
            description: "MLXArray를 사용하여 배열을 생성하고 기본 연산을 수행합니다."
        ),
        Chapter(
            id: 3,
            title: "배열 연산",
            subtitle: "Array Operations",
            icon: "function",
            description: "수학 연산, 브로드캐스팅, 리듀스 연산을 학습합니다."
        ),
        Chapter(
            id: 4,
            title: "디바이스 관리",
            subtitle: "Device Management",
            icon: "cpu",
            description: "CPU와 GPU 간 연산 및 통합 메모리 모델을 이해합니다."
        ),
        Chapter(
            id: 5,
            title: "자동 미분",
            subtitle: "Automatic Differentiation",
            icon: "chart.line.uptrend.xyaxis",
            description: "grad 함수를 사용한 자동 미분과 역전파를 학습합니다."
        ),
        Chapter(
            id: 6,
            title: "신경망 기초",
            subtitle: "MLXNN Basics",
            icon: "brain",
            description: "MLXNN 모듈을 사용하여 기본 신경망 레이어를 구성합니다."
        ),
        Chapter(
            id: 7,
            title: "활성화 & 손실 함수",
            subtitle: "Activation & Loss",
            icon: "waveform.path.ecg",
            description: "ReLU, Softmax 등 활성화 함수와 손실 함수를 학습합니다."
        ),
        Chapter(
            id: 8,
            title: "옵티마이저",
            subtitle: "Optimizers",
            icon: "dial.low",
            description: "SGD, Adam 등 옵티마이저를 사용하여 모델을 학습합니다."
        ),
        Chapter(
            id: 9,
            title: "모델 저장/로드",
            subtitle: "Save & Load",
            icon: "arrow.down.doc",
            description: "학습된 모델의 가중치를 저장하고 불러옵니다."
        ),
        Chapter(
            id: 10,
            title: "MNIST 분류기",
            subtitle: "MNIST Classifier",
            icon: "number",
            description: "실전 예제: MNIST 손글씨 숫자 분류 모델을 학습합니다."
        ),
        Chapter(
            id: 11,
            title: "LLM 텍스트 생성",
            subtitle: "Text Generation",
            icon: "text.bubble",
            description: "MLX-LM을 사용하여 대형 언어 모델로 텍스트를 생성합니다."
        ),
        Chapter(
            id: 12,
            title: "VLM 이미지 분석",
            subtitle: "Vision Language Model",
            icon: "eye",
            description: "비전 언어 모델을 사용하여 이미지를 분석합니다."
        ),
        Chapter(
            id: 13,
            title: "LoRA 파인튜닝",
            subtitle: "Low-Rank Adaptation",
            icon: "slider.horizontal.3",
            description: "LoRA를 사용하여 모델을 효율적으로 파인튜닝합니다."
        ),
        Chapter(
            id: 14,
            title: "이미지 생성",
            subtitle: "Stable Diffusion",
            icon: "photo.artframe",
            description: "Stable Diffusion을 사용하여 이미지를 생성합니다."
        ),
        Chapter(
            id: 15,
            title: "생태계 & 다음 단계",
            subtitle: "Ecosystem & Next Steps",
            icon: "apple.logo",
            description: "MLX 생태계와 추가 학습 리소스를 안내합니다."
        )
    ]
}
