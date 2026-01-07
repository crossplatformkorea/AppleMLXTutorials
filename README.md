<p align="center">
  <img src="logo.png" alt="Apple MLX Tutorials" width="128">
</p>

<h1 align="center">Apple MLX Tutorials</h1>

<p align="center">
  Apple Silicon에서 MLX Swift 프레임워크를 배우는 튜토리얼 앱
</p>

## 요구사항

- macOS 14.0+
- Apple Silicon (M1/M2/M3/M4)

## 설치

[Releases](https://github.com/crossplatformkorea/AppleMLXTutorials/releases)에서 DMG 파일을 다운로드하세요.

## 튜토리얼 목차

### 기본 (Chapter 1-5)

| #   | 제목          | 설명                                           |
| --- | ------------- | ---------------------------------------------- |
| 1   | MLX 소개      | MLX 프레임워크 개요, Apple Silicon 최적화 특징 |
| 2   | 배열 기초     | MLXArray 생성, 인덱싱, 슬라이싱                |
| 3   | 배열 연산     | 수학 연산, 브로드캐스팅, 행렬 연산             |
| 4   | 디바이스 관리 | CPU/GPU 선택, 통합 메모리 활용                 |
| 5   | 자동 미분     | grad 함수로 그래디언트 계산                    |

### 신경망 (Chapter 6-10)

| #   | 제목               | 설명                              |
| --- | ------------------ | --------------------------------- |
| 6   | 신경망 기초        | MLXNN 모듈, Linear/Conv 레이어    |
| 7   | 활성화 & 손실 함수 | ReLU, Softmax, Cross-Entropy 구현 |
| 8   | 옵티마이저         | SGD, Adam으로 모델 학습           |
| 9   | 모델 저장/로드     | safetensors 형식 사용             |
| 10  | MNIST 분류기       | 손글씨 숫자 인식 실습             |

### 고급 (Chapter 11-15)

| #   | 제목            | 설명                                         |
| --- | --------------- | -------------------------------------------- |
| 11  | LLM 텍스트 생성 | Llama, Qwen 등 대형 언어 모델 실행           |
| 12  | VLM 이미지 분석 | 이미지 업로드 후 AI 분석 (SmolVLM, Qwen2-VL) |
| 13  | LoRA 파인튜닝   | 적은 파라미터로 모델 커스터마이징            |
| 14  | 이미지 생성     | Stable Diffusion SDXL Turbo로 이미지 생성    |
| 15  | 생태계          | mlx-community, Hugging Face 리소스           |

## 개발

```bash
brew install xcodegen
xcodegen generate
open AppleMLXTutorials.xcodeproj
```

## 링크

- [MLX Swift](https://github.com/ml-explore/mlx-swift)
- [MLX Swift Examples](https://github.com/ml-explore/mlx-swift-examples)

---

Made with love by [Cross Platform Korea](https://www.youtube.com/@crossplatformkorea)
