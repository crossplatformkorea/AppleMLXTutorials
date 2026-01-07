import SwiftUI
import MLX
import MLXLLM
import MLXLMCommon
import MLXOptimizers

/// Chapter 13: LoRA 파인튜닝
struct Chapter13View: View {
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
            **LoRA (Low-Rank Adaptation)**는 대형 모델을 효율적으로 파인튜닝하는 기법입니다.

            **LoRA 원리:**
            • 전체 가중치 대신 저랭크 행렬만 학습
            • W' = W + BA (B: d×r, A: r×k, r << min(d,k))
            • 원본 모델 가중치는 고정

            **장점:**
            • **메모리 효율** - 전체 파인튜닝의 1/10 메모리
            • **빠른 학습** - 학습 파라미터 수 대폭 감소
            • **모델 병합** - 여러 LoRA를 조합 가능
            • **저장 용량** - LoRA 어댑터만 저장 (수 MB)

            **활용 사례:**
            • 도메인 특화 (의료, 법률, 금융)
            • 스타일 조정 (격식체, 친근체)
            • 언어 적응 (한국어 강화)
            • 특정 태스크 (코드 생성, 요약)
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

            Text("**1. LoRA 설정 및 적용:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLXLLM
                import MLXLMCommon
                import MLXOptimizers

                // 모델 로드
                let modelConfig = LLMRegistry.mistral7B4bit
                let modelContainer = try await LLMModelFactory.shared.loadContainer(
                    configuration: modelConfig
                )

                // LoRA 설정 (기본값: 4개 레이어, rank 8)
                let loraConfig = LoRAConfiguration(numLayers: 4)

                // 모델에 LoRA 어댑터 적용
                let loraAdapter = try await modelContainer.perform { context in
                    try LoRAContainer.from(
                        model: context.model,
                        configuration: loraConfig
                    )
                }
                """)

            Text("**2. 학습 데이터 준비 (JSONL 형식):**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // train.jsonl 예시:
                // {"text": "<s>[INST] 질문 [/INST] 답변</s>"}
                // {"text": "<s>[INST] Swift란? [/INST] Apple의 프로그래밍 언어입니다.</s>"}

                // JSONL 파일 로드
                let trainData = try MLXLLM.loadLoRAData(url: trainURL)
                let validData = try MLXLLM.loadLoRAData(url: validURL)
                """)

            Text("**3. LoRA 학습:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // 학습 파라미터
                let parameters = LoRATrain.Parameters(
                    batchSize: 1,
                    iterations: 200
                )

                // 옵티마이저
                let optimizer = Adam(learningRate: 1e-5)

                // 학습 실행
                try await modelContainer.perform { context in
                    try LoRATrain.train(
                        model: context.model,
                        train: trainData,
                        validate: validData,
                        optimizer: optimizer,
                        tokenizer: context.tokenizer,
                        parameters: parameters
                    ) { progress in
                        switch progress {
                        case .train(let i, let loss, _, _):
                            print("Step \\(i): loss = \\(loss)")
                        case .validation(let loss, _):
                            print("Validation: loss = \\(loss)")
                        default:
                            break
                        }
                        return .more  // 계속 학습
                    }
                }
                """)

            Text("**4. LoRA 평가:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                // 테스트 데이터로 평가
                let testLoss = await modelContainer.perform { context in
                    LoRATrain.evaluate(
                        model: context.model,
                        dataset: testData,
                        tokenizer: context.tokenizer,
                        batchSize: 1,
                        batchCount: 0
                    )
                }

                print("Test loss: \\(testLoss)")
                print("Perplexity: \\(exp(testLoss))")
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("실행 정보", systemImage: "play.circle")
                .font(.title2.bold())

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Label("LoRA 학습 요구사항", systemImage: "exclamationmark.triangle")
                        .font(.headline)
                        .foregroundStyle(.orange)

                    Text("""
                    LoRA 파인튜닝을 실행하려면:

                    1. **충분한 메모리**
                       • 7B 모델 LoRA: ~16GB RAM
                       • 1-3B 모델 LoRA: ~8GB RAM

                    2. **학습 데이터**
                       • JSONL 형식 필수
                       • 최소 100-1000개 샘플

                    3. **학습 시간**
                       • 200 iterations: ~10-30분
                       • GPU 가속 필수 (Apple Silicon)

                    **공식 예제:**
                    mlx-swift-examples의 LoRATrainingExample 참고
                    """)
                    .font(.body)

                    Link(destination: URL(string: "https://github.com/ml-explore/mlx-swift-examples/tree/main/Applications/LoRATrainingExample")!) {
                        Label("LoRA Training Example 보기", systemImage: "arrow.up.right.square")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("LoRA 설정 정보", systemImage: "info.circle")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                if isRunning {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            if !output.isEmpty {
                GroupBox {
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

            result += "== LoRA 파인튜닝 가이드 (mlx-swift-lm) ==\n\n"

            result += "주요 클래스/구조체:\n"
            result += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
            result += "• LoRAConfiguration: LoRA 설정\n"
            result += "  - numLayers: 적용할 레이어 수 (기본 4)\n"
            result += "  - rank: 저랭크 차원 (기본 8)\n\n"

            result += "• LoRAContainer: LoRA 어댑터 관리\n"
            result += "  - from(model:configuration:): 어댑터 적용\n\n"

            result += "• LoRATrain: 학습 유틸리티\n"
            result += "  - train(): 학습 실행\n"
            result += "  - evaluate(): 모델 평가\n\n"

            result += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"

            result += "권장 하이퍼파라미터:\n"
            result += "• learning_rate: 1e-5\n"
            result += "• batch_size: 1-4\n"
            result += "• iterations: 100-500\n"
            result += "• numLayers: 4-8\n\n"

            result += "데이터 형식 (JSONL):\n"
            result += "• 각 줄에 {\"text\": \"...\"} JSON 객체\n"
            result += "• Instruction 형식 권장:\n"
            result += "  <s>[INST] 질문 [/INST] 답변</s>\n\n"

            result += "필요 파일:\n"
            result += "• train.jsonl: 학습 데이터\n"
            result += "• valid.jsonl: 검증 데이터\n"
            result += "• test.jsonl: 테스트 데이터"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter13View()
        .frame(width: 800, height: 800)
}
