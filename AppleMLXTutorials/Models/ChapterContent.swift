import Foundation

/// Provides copyable full content for each chapter (description + code)
enum ChapterContent {
    static func getCode(for chapterId: Int) -> String {
        switch chapterId {
        case 1:
            return chapter1Content
        case 2:
            return chapter2Content
        case 3:
            return chapter3Content
        case 4:
            return chapter4Content
        case 5:
            return chapter5Content
        case 6:
            return chapter6Content
        case 7:
            return chapter7Content
        case 8:
            return chapter8Content
        case 9:
            return chapter9Content
        case 10:
            return chapter10Content
        case 11:
            return chapter11Content
        case 12:
            return chapter12Content
        case 13:
            return chapter13Content
        case 14:
            return chapter14Content
        case 15:
            return chapter15Content
        default:
            return ""
        }
    }

    // MARK: - Chapter 1: MLX 소개

    static let chapter1Content = """
# Chapter 1: MLX 소개

## 개요

**MLX**는 Apple Silicon에서 머신러닝을 위해 설계된 배열 프레임워크입니다.
Apple 머신러닝 연구팀에서 개발했으며, NumPy와 유사한 API를 제공합니다.

**핵심 특징:**
• 통합 메모리 모델 - CPU와 GPU가 메모리를 공유하여 데이터 복사 불필요
• 지연 계산(Lazy Evaluation) - 배열은 필요할 때만 계산됨
• 자동 미분 - 함수 변환을 통한 그래디언트 자동 계산
• 다중 디바이스 - CPU, GPU에서 유연하게 연산 실행

**MLX Swift 패키지 구성:**
• MLX - 핵심 배열 프레임워크
• MLXNN - 신경망 모듈
• MLXOptimizers - 최적화 알고리즘
• MLXRandom - 난수 생성

**지원 플랫폼:**
• macOS 14.0+ (Apple Silicon)
• iOS 17.0+ (Apple Silicon)

## 설치 방법

**Package.swift에 추가:**

```swift
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
```

**기본 사용법:**

```swift
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
```
"""

    // MARK: - Chapter 2: 배열 기초

    static let chapter2Content = """
# Chapter 2: 배열 기초

## 개요

`MLXArray`는 MLX의 핵심 데이터 구조입니다.
NumPy의 ndarray와 유사하게 다차원 배열을 표현합니다.

**주요 특징:**
• 다양한 데이터 타입 지원 (Float32, Int32, Bool 등)
• 다차원 배열 (스칼라, 벡터, 행렬, 텐서)
• 지연 계산 - eval() 호출 시 실제 계산 수행
• 브로드캐스팅 지원

**데이터 타입:**
• .float32, .float16, .bfloat16 - 부동소수점
• .int32, .int64, .uint32 - 정수
• .bool - 불리언
• .complex64 - 복소수

## 코드 예제

**배열 생성 방법:**

```swift
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
```

**배열 속성:**

```swift
let arr = MLXArray([[1, 2, 3], [4, 5, 6]])

arr.shape       // [2, 3] - 형태
arr.ndim        // 2 - 차원 수
arr.size        // 6 - 전체 요소 수
arr.dtype       // .int32 - 데이터 타입
```
"""

    // MARK: - Chapter 3: 배열 연산

    static let chapter3Content = """
# Chapter 3: 배열 연산

## 개요

MLX는 NumPy와 유사한 다양한 배열 연산을 지원합니다.
모든 연산은 지연 계산되며, eval() 호출 시 실제로 실행됩니다.

**지원하는 연산:**
• 산술 연산 (+, -, *, /)
• 수학 함수 (sqrt, exp, log, pow 등)
• 축소 연산 (sum, mean, max, min)
• 행렬 연산 (matmul, transpose)
• 브로드캐스팅 자동 지원

## 코드 예제

**산술 연산:**

```swift
import MLX

let a = MLXArray([1.0, 2.0, 3.0, 4.0])
let b = MLXArray([5.0, 6.0, 7.0, 8.0])

let sum = a + b        // 요소별 덧셈
let diff = a - b       // 요소별 뺄셈
let prod = a * b       // 요소별 곱셈
let div = a / b        // 요소별 나눗셈
```

**수학 함수:**

```swift
let squared = MLX.pow(a, 2)    // 제곱
let sqrtVal = MLX.sqrt(a)      // 제곱근
let expVal = MLX.exp(a)        // 지수
let logVal = MLX.log(a)        // 로그
```

**축소 연산:**

```swift
let matrix = MLXArray([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])

let total = matrix.sum()                    // 전체 합
let rowSum = matrix.sum(axis: 1)            // 행별 합
let colSum = matrix.sum(axis: 0)            // 열별 합
let meanVal = matrix.mean()                 // 평균
let maxVal = matrix.max()                   // 최대값
let minVal = matrix.min()                   // 최소값
```

**행렬 연산:**

```swift
let m1 = MLXArray([[1.0, 2.0], [3.0, 4.0]])
let m2 = MLXArray([[5.0, 6.0], [7.0, 8.0]])

let matmul = MLX.matmul(m1, m2)             // 행렬 곱셈
let transposed = m1.transposed()            // 전치
```
"""

    // MARK: - Chapter 4: 디바이스와 스트림

    static let chapter4Content = """
# Chapter 4: 디바이스와 스트림

## 개요

MLX는 다양한 디바이스(CPU, GPU)에서 연산을 실행할 수 있습니다.
Apple Silicon의 통합 메모리 구조 덕분에 디바이스 간 데이터 복사가 필요 없습니다.

**핵심 개념:**
• Device - 연산이 실행되는 하드웨어 (CPU, GPU)
• Stream - 연산을 순차적으로 실행하는 큐
• 통합 메모리 - CPU와 GPU가 동일한 메모리 공간 공유

**장점:**
• 데이터 복사 오버헤드 없음
• 유연한 디바이스 선택
• 비동기 연산 지원

## 코드 예제

**디바이스 정보:**

```swift
import MLX

let defaultDevice = Device.defaultDevice()
let cpu = Device.cpu
let gpu = Device.gpu

// 디바이스 지정하여 배열 생성
let cpuArray = MLXArray([1, 2, 3])  // 기본 디바이스
// GPU에서 연산하려면:
// let result = MLX.matmul(a, b, stream: .gpu)
```

**스트림을 사용한 비동기 연산:**

```swift
let streamA = Stream(device: .gpu)
let streamB = Stream(device: .gpu)

// 여러 스트림에서 병렬 연산
let a = MLXArray([1.0, 2.0, 3.0])
let b = MLXArray([4.0, 5.0, 6.0])
let result1 = a + b  // 기본 스트림
// let result2 = MLX.matmul(matrix1, matrix2, stream: streamA)
// let result3 = MLX.matmul(matrix3, matrix4, stream: streamB)

// 동기화
eval(result1)  // 계산 완료 대기

// 메모리 관리
// MLX.GPU.clearCache()  // GPU 캐시 정리
```
"""

    // MARK: - Chapter 5: 자동 미분

    static let chapter5Content = """
# Chapter 5: 자동 미분 (Automatic Differentiation)

## 개요

MLX는 강력한 자동 미분 기능을 제공합니다.
함수 변환을 통해 그래디언트를 자동으로 계산할 수 있습니다.

**핵심 함수:**
• grad - 함수의 그래디언트를 계산하는 새 함수 반환
• valueAndGrad - 값과 그래디언트를 동시에 계산
• 체인 룰 자동 적용

**활용 분야:**
• 신경망 학습
• 최적화 문제
• 과학 계산

## 코드 예제

**기본 그래디언트 계산:**

```swift
import MLX

// f(x) = x^2의 그래디언트 계산
let gradSquare = grad { arrays in
    let x = arrays[0]
    return [x * x]
}

let x = MLXArray([3.0])
let gradient = gradSquare([x])  // df/dx = 2x = 6.0
```

**값과 그래디언트 동시 계산:**

```swift
let valueAndGradFn = valueAndGrad { arrays in
    let x = arrays[0]
    return [x * x]
}

let (values, grads) = valueAndGradFn([x])
// values = [9.0], grads = [[6.0]]
```

**신경망에서의 그래디언트:**

```swift
// loss = (prediction - target)^2
func mse(_ pred: MLXArray, _ target: MLXArray) -> MLXArray {
    let diff = pred - target
    return (diff * diff).mean()
}

// 손실 함수의 그래디언트 계산
let prediction = MLXArray([1.0, 2.0, 3.0])
let target = MLXArray([1.5, 2.5, 3.5])

// grad를 사용하여 그래디언트 계산
let lossGrad = grad { arrays in
    let pred = arrays[0]
    let tgt = arrays[1]
    let diff = pred - tgt
    return [(diff * diff).mean()]
}

let gradients = lossGrad([prediction, target])
```
"""

    // MARK: - Chapter 6: 신경망 모듈 (MLXNN)

    static let chapter6Content = """
# Chapter 6: 신경망 모듈 (MLXNN)

## 개요

MLXNN은 신경망 구축을 위한 고수준 모듈을 제공합니다.
PyTorch의 nn.Module과 유사한 패턴을 따릅니다.

**제공 레이어:**
• Linear - 완전 연결 레이어
• Conv2d - 2D 합성곱 레이어
• BatchNorm, LayerNorm - 정규화 레이어
• Dropout - 드롭아웃 레이어
• Embedding - 임베딩 레이어

**특징:**
• Module 프로토콜 기반
• 자동 파라미터 관리
• 중첩 모듈 지원

## 코드 예제

**기본 레이어:**

```swift
import MLX
import MLXNN

let linear = Linear(inputDimensions: 784, outputDimensions: 128)
let conv = Conv2d(inputChannels: 3, outputChannels: 64, kernelSize: 3)
```

**신경망 정의:**

```swift
class SimpleMLP: Module {
    let fc1: Linear
    let fc2: Linear
    let fc3: Linear

    init() {
        fc1 = Linear(inputDimensions: 784, outputDimensions: 256)
        fc2 = Linear(inputDimensions: 256, outputDimensions: 128)
        fc3 = Linear(inputDimensions: 128, outputDimensions: 10)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        var x = x
        x = relu(fc1(x))
        x = relu(fc2(x))
        x = fc3(x)
        return x
    }
}

// 모델 생성 및 사용
let model = SimpleMLP()
let input = MLXArray.zeros([1, 784])
let output = model(input)

// 파라미터 접근
let params = model.parameters()
// params는 중첩된 딕셔너리 구조
```
"""

    // MARK: - Chapter 7: 활성화 함수와 손실 함수

    static let chapter7Content = """
# Chapter 7: 활성화 함수와 손실 함수

## 개요

MLXNN은 다양한 활성화 함수와 손실 함수를 제공합니다.

**활성화 함수:**
• ReLU, GELU, SiLU - 비선형 활성화
• Sigmoid, Tanh - 범위 제한 활성화
• Softmax - 확률 분포 변환

**손실 함수:**
• Cross Entropy - 분류 문제
• MSE - 회귀 문제
• Binary Cross Entropy - 이진 분류

## 코드 예제

**활성화 함수:**

```swift
import MLX
import MLXNN

let x = MLXArray([-2.0, -1.0, 0.0, 1.0, 2.0])

let reluOut = relu(x)           // max(0, x)
let geluOut = gelu(x)           // Gaussian Error Linear Unit
let siluOut = silu(x)           // x * sigmoid(x)
let sigmoidOut = sigmoid(x)     // 1 / (1 + exp(-x))
let tanhOut = tanh(x)           // 쌍곡탄젠트
let softmaxOut = softmax(x)     // exp(x) / sum(exp(x))
```

**손실 함수:**

```swift
let predictions = MLXArray([[0.9, 0.1], [0.2, 0.8]])
let targets = MLXArray([0, 1])  // 클래스 인덱스

// Cross Entropy Loss
let logits = MLXArray([[2.0, 0.5], [0.3, 1.8]])
// crossEntropy(logits: logits, targets: targets)

// MSE Loss
let pred = MLXArray([1.0, 2.0, 3.0])
let target = MLXArray([1.1, 2.2, 2.8])
let mseLoss = (pred - target).pow(2).mean()

// Binary Cross Entropy
let binaryPred = MLXArray([0.9, 0.2, 0.8])
let binaryTarget = MLXArray([1.0, 0.0, 1.0])
// binaryCrossEntropy(binaryPred, binaryTarget)
```
"""

    // MARK: - Chapter 8: 최적화

    static let chapter8Content = """
# Chapter 8: 최적화 (Optimizers)

## 개요

MLXOptimizers는 다양한 최적화 알고리즘을 제공합니다.

**제공 옵티마이저:**
• SGD - 확률적 경사 하강법
• Adam - Adaptive Moment Estimation
• AdamW - Weight Decay 포함 Adam
• RMSprop, Adagrad 등

**학습 과정:**
1. Forward pass - 예측 계산
2. Loss 계산
3. Backward pass - 그래디언트 계산
4. 파라미터 업데이트

## 코드 예제

**옵티마이저 생성:**

```swift
import MLX
import MLXNN
import MLXOptimizers

let sgd = SGD(learningRate: 0.01)
let sgdMomentum = SGD(learningRate: 0.01, momentum: 0.9)
let adam = Adam(learningRate: 0.001)
let adamW = AdamW(learningRate: 0.001, weightDecay: 0.01)
```

**모델 학습 루프:**

```swift
class SimpleModel: Module {
    let layer: Linear

    init() {
        layer = Linear(inputDimensions: 10, outputDimensions: 1)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        layer(x)
    }
}

let model = SimpleModel()
let optimizer = Adam(learningRate: 0.001)

// 학습 스텝
func trainStep(model: SimpleModel, optimizer: Adam, x: MLXArray, y: MLXArray) {
    // 손실 함수와 그래디언트 계산
    let lossAndGrad = valueAndGrad(model: model) { model, x in
        let pred = model(x)
        return mseLoss(pred, y)
    }

    let (loss, grads) = lossAndGrad(model, x)

    // 파라미터 업데이트
    optimizer.update(model: model, gradients: grads)

    // 계산 실행
    eval(model, optimizer)
}
```
"""

    // MARK: - Chapter 9: 모델 저장 및 로드

    static let chapter9Content = """
# Chapter 9: 모델 저장 및 로드

## 개요

MLX는 모델 파라미터를 safetensors 형식으로 저장하고 로드할 수 있습니다.

**지원 형식:**
• .safetensors - 안전하고 빠른 텐서 저장 형식
• 딕셔너리 기반 파라미터 관리

**사용 사례:**
• 학습된 모델 저장
• 체크포인트 생성
• 모델 공유 및 배포

## 코드 예제

**모델 정의:**

```swift
import MLX
import MLXNN
import Foundation

class SaveableModel: Module {
    let fc1: Linear
    let fc2: Linear

    init() {
        fc1 = Linear(inputDimensions: 10, outputDimensions: 5)
        fc2 = Linear(inputDimensions: 5, outputDimensions: 2)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        var x = x
        x = relu(fc1(x))
        x = fc2(x)
        return x
    }
}

let model = SaveableModel()
```

**파라미터 저장:**

```swift
let savePath = URL(fileURLWithPath: "/tmp/model_params.safetensors")

// 파라미터를 딕셔너리로 변환하여 저장
let params = model.parameters()
let flatParams = params.flattened()
let paramsDict = Dictionary(uniqueKeysWithValues: flatParams)
try save(arrays: paramsDict, url: savePath)
```

**파라미터 로드:**

```swift
let loadedParams = try loadArrays(url: savePath)

// 모델에 파라미터 적용
// model.update(parameters: loadedParams)
```

**체크포인트 저장:**

```swift
struct ModelState: Codable {
    var epoch: Int
    var loss: Float
}

let state = ModelState(epoch: 10, loss: 0.01)
let stateData = try JSONEncoder().encode(state)
```
"""

    // MARK: - Chapter 10: MNIST 예제

    static let chapter10Content = """
# Chapter 10: MNIST 손글씨 분류 예제

## 개요

MNIST 데이터셋을 사용한 손글씨 숫자 분류 신경망 예제입니다.

**MNIST 데이터셋:**
• 28x28 픽셀 흑백 이미지
• 0-9 숫자 분류
• 60,000 학습, 10,000 테스트 이미지

**모델 구조:**
• Conv2d 레이어로 특징 추출
• Max Pooling으로 다운샘플링
• Linear 레이어로 분류

## 코드 예제

**CNN 모델 정의:**

```swift
import MLX
import MLXNN
import MLXOptimizers
import MLXRandom

class MNISTModel: Module {
    let conv1: Conv2d
    let conv2: Conv2d
    let fc1: Linear
    let fc2: Linear

    init() {
        conv1 = Conv2d(inputChannels: 1, outputChannels: 32, kernelSize: 3)
        conv2 = Conv2d(inputChannels: 32, outputChannels: 64, kernelSize: 3)
        fc1 = Linear(inputDimensions: 64 * 5 * 5, outputDimensions: 128)
        fc2 = Linear(inputDimensions: 128, outputDimensions: 10)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        var x = x
        // Conv layers with max pooling
        x = maxPool2d(relu(conv1(x)), kernelSize: 2)
        x = maxPool2d(relu(conv2(x)), kernelSize: 2)
        // Flatten
        x = x.reshaped([x.shape[0], -1])
        // FC layers
        x = relu(fc1(x))
        x = fc2(x)
        return x
    }
}
```

**학습 루프:**

```swift
let model = MNISTModel()
let optimizer = Adam(learningRate: 0.001)

func trainEpoch(images: MLXArray, labels: MLXArray) -> Float {
    let (loss, grads) = valueAndGrad(model: model) { model, images in
        let logits = model(images)
        return crossEntropy(logits: logits, targets: labels).mean()
    }(model, images)

    optimizer.update(model: model, gradients: grads)
    eval(model, optimizer)

    return loss.item(Float.self)
}

// 예측
func predict(images: MLXArray) -> MLXArray {
    let logits = model(images)
    return argMax(logits, axis: 1)
}
```
"""

    // MARK: - Chapter 11: LLM 추론

    static let chapter11Content = """
# Chapter 11: LLM 추론 (MLXLLM)

## 개요

MLXLLM을 사용하여 Apple Silicon에서 대형 언어 모델을 실행합니다.

**이 챕터에서 할 수 있는 것:**
• Hugging Face에서 모델 자동 다운로드
• 로컬에서 AI 텍스트 생성
• 다양한 모델 선택 및 비교

**사용 가능한 모델들:**
• mlx-community/SmolLM-135M-Instruct-4bit (~76MB)
• mlx-community/Qwen2.5-0.5B-Instruct-4bit (~400MB)
• mlx-community/Llama-3.2-1B-Instruct-4bit (~700MB)
• mlx-community/Phi-3.5-mini-instruct-4bit (~2GB)

## 코드 예제

**모델 로드:**

```swift
import MLX
import MLXLLM
import MLXLMCommon

let modelConfiguration = ModelConfiguration(
    id: "mlx-community/SmolLM-135M-Instruct-4bit"
)

let container = try await LLMModelFactory.shared.loadContainer(
    configuration: modelConfiguration
) { progress in
    print("다운로드 진행: \\(Int(progress.fractionCompleted * 100))%")
}
```

**텍스트 생성:**

```swift
let prompt = "Swift 프로그래밍의 장점은"

// UserInput을 사용하여 LMInput 생성
let userInput = UserInput(prompt: .init(prompt))
let lmInput = try await container.prepare(input: userInput)

let parameters = GenerateParameters(
    temperature: 0.7
)

// AsyncStream으로 토큰 생성
let stream = try container.generate(
    input: lmInput,
    parameters: parameters
)

var output = ""
for try await generation in stream {
    switch generation {
    case .chunk(let text):
        output += text
        print(text, terminator: "")
    case .info(let info):
        print("\\n초당 토큰: \\(info.tokensPerSecond)")
    case .toolCall:
        break
    }
}
```
"""

    // MARK: - Chapter 12: VLM 추론

    static let chapter12Content = """
# Chapter 12: Vision Language Model (VLM)

## 개요

VLM(Vision Language Model)은 이미지와 텍스트를 함께 이해하는 멀티모달 AI 모델입니다.

**VLM 활용 사례:**
• 이미지 설명 생성
• 시각적 질문 응답 (VQA)
• 이미지 기반 대화

**지원 모델:**
• paligemma - Google의 VLM
• llava - LLaVA 아키텍처
• qwen-vl - Qwen의 비전 모델

## 코드 예제 (향후 지원)

**VLM 모델 로드:**

```swift
import MLX
// import MLXVLM  // VLM 패키지 필요

// VLM 모델 로드
// let vlmConfig = ModelConfiguration(id: "mlx-community/paligemma-3b-mix-224-4bit")
```

**이미지 처리:**

```swift
// 이미지 처리
// let image = loadImage(from: url)
// let processedImage = preprocessImage(image, size: 224)
```

**멀티모달 입력:**

```swift
// 멀티모달 입력
// let prompt = "이 이미지를 설명해주세요"
// let result = try await vlm.generate(
//     image: processedImage,
//     prompt: prompt
// )
```

**이미지 질문 응답:**

```swift
// 이미지 질문 응답
// let question = "이 사진에서 사람이 몇 명인가요?"
// let answer = try await vlm.answer(
//     image: processedImage,
//     question: question
// )
```

**지원되는 VLM 모델들:**
• paligemma-3b-mix-224
• llava-v1.6
• qwen-vl
"""

    // MARK: - Chapter 13: LoRA 미세조정

    static let chapter13Content = """
# Chapter 13: LoRA 미세조정

## 개요

LoRA(Low-Rank Adaptation)는 대형 모델을 효율적으로 미세조정하는 기법입니다.

**LoRA의 장점:**
• 학습 파라미터 수 대폭 감소
• 메모리 효율적
• 빠른 학습 속도
• 여러 어댑터 교체 가능

**핵심 개념:**
• 저랭크 분해로 가중치 업데이트 근사
• 원본 가중치는 동결
• 작은 어댑터만 학습

## 코드 예제

**LoRA 설정:**

```swift
import MLX
import MLXNN

struct LoRAConfig {
    var rank: Int = 8           // LoRA 랭크
    var alpha: Float = 16.0     // 스케일링 팩터
    var dropout: Float = 0.1    // 드롭아웃
    var targetModules: [String] = ["q_proj", "v_proj"]  // 대상 모듈
}
```

**LoRA 레이어 구현:**

```swift
class LoRALinear: Module {
    let original: Linear
    let loraA: Linear      // 저랭크 분해 A
    let loraB: Linear      // 저랭크 분해 B
    let scale: Float

    init(linear: Linear, rank: Int, alpha: Float) {
        original = linear
        loraA = Linear(
            inputDimensions: linear.inputDimensions,
            outputDimensions: rank,
            bias: false
        )
        loraB = Linear(
            inputDimensions: rank,
            outputDimensions: linear.outputDimensions,
            bias: false
        )
        scale = alpha / Float(rank)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        let originalOut = original(x)
        let loraOut = loraB(loraA(x)) * scale
        return originalOut + loraOut
    }
}
```

**LoRA 학습 과정:**
1. 기본 모델 로드
2. LoRA 어댑터 추가
3. LoRA 파라미터만 학습 (기존 파라미터 동결)
4. 어댑터 저장
"""

    // MARK: - Chapter 14: Stable Diffusion

    static let chapter14Content = """
# Chapter 14: Stable Diffusion

## 개요

Stable Diffusion은 텍스트 프롬프트로 이미지를 생성하는 AI 모델입니다.

**기능:**
• Text-to-Image - 텍스트로 이미지 생성
• Image-to-Image - 이미지 변환
• Inpainting - 이미지 수정

**핵심 컴포넌트:**
• CLIP Text Encoder - 텍스트 임베딩
• U-Net - 노이즈 예측
• VAE - 이미지 인코딩/디코딩

## 코드 예제 (향후 지원)

**Stable Diffusion 파이프라인:**

```swift
import MLX
// import MLXStableDiffusion  // SD 패키지 필요

// let pipeline = try await StableDiffusionPipeline.load(
//     model: "stabilityai/stable-diffusion-2-1"
// )
```

**이미지 생성 설정:**

```swift
struct GenerationConfig {
    var prompt: String
    var negativePrompt: String = ""
    var width: Int = 512
    var height: Int = 512
    var steps: Int = 20
    var guidanceScale: Float = 7.5
    var seed: Int? = nil
}
```

**이미지 생성:**

```swift
// let config = GenerationConfig(
//     prompt: "A beautiful sunset over mountains, digital art",
//     negativePrompt: "blurry, low quality",
//     steps: 30
// )

// let image = try await pipeline.generate(config: config) { step in
//     print("Step \\(step)")
// }

// 이미지 저장
// try image.write(to: URL(fileURLWithPath: "output.png"))
```

**Image-to-Image:**

```swift
// let inputImage = loadImage(from: url)
// let outputImage = try await pipeline.imageToImage(
//     input: inputImage,
//     prompt: "Transform to oil painting style",
//     strength: 0.75
// )
```
"""

    // MARK: - Chapter 15: MLX 생태계

    static let chapter15Content = """
# Chapter 15: MLX 생태계 및 리소스

## 개요

MLX 생태계의 다양한 리소스와 도구들을 소개합니다.

**핵심 저장소:**
• mlx-swift - Swift API for MLX
• mlx-swift-lm - LLM/VLM 라이브러리
• mlx-swift-examples - 예제 앱들

## 패키지 구성

**Package.swift 설정:**

```swift
dependencies: [
    .package(url: "https://github.com/ml-explore/mlx-swift", from: "0.21.2"),
    .package(url: "https://github.com/ml-explore/mlx-swift-lm", branch: "main"),
]
```

**사용 가능한 제품들:**
• MLX - 핵심 배열 프레임워크
• MLXNN - 신경망 모듈
• MLXOptimizers - 최적화 알고리즘
• MLXRandom - 난수 생성
• MLXLLM - LLM 추론
• MLXLMCommon - LLM 공통 유틸리티

## 리소스

**Hugging Face 모델 허브:**
https://huggingface.co/mlx-community

**커뮤니티 모델들:**
• SmolLM-135M-Instruct-4bit
• Qwen2.5-0.5B-Instruct-4bit
• Llama-3.2-1B-Instruct-4bit
• Phi-3.5-mini-instruct-4bit
• gemma-2-2b-it-4bit

**문서 및 리소스:**
• MLX 문서: https://ml-explore.github.io/mlx/build/html/index.html
• MLX Swift 문서: https://ml-explore.github.io/mlx-swift/
• GitHub: https://github.com/ml-explore

**예제 프로젝트:**
• 텍스트 생성 앱
• 이미지 생성 앱
• 음성 인식 앱 (Whisper)
"""
}
