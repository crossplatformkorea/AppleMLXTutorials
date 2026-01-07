import SwiftUI
import MLX
import MLXNN

/// Chapter 9: 모델 저장/로드
struct Chapter9View: View {
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
            Label("Overview", systemImage: "info.circle")
                .font(.title2.bold())

            Text("""
            Saving and loading trained models is essential for real-world applications.

            **Save Formats:**
            • **safetensors** - Recommended, safe and fast
            • **npz** - NumPy compatible
            • **gguf** - Commonly used for LLM models

            **What to Save:**
            • Model parameters (weights, biases)
            • Optimizer state (momentum, etc.)
            • Training checkpoints

            **MLX Save API:**
            • `save(arrays:url:)` - Save as safetensors
            • `loadArrays(url:)` - Load from file
            • `Module.parameters()` - Parameter dictionary

            **Checkpoints:**
            Save models during training to resume later or
            preserve the best performing model.
            """)
            .font(.body)
            .textSelection(.enabled)
        }
    }

    // MARK: - Code Section

    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Code Example", systemImage: "chevron.left.forwardslash.chevron.right")
                .font(.title2.bold())

            Text("**모델 파라미터 저장:**")
                .font(.headline)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // 모델 생성 및 학습
                let model = Linear(10, 2)

                // 파라미터를 딕셔너리로 추출
                let params = model.parameters()

                // safetensors 형식으로 저장
                let url = URL(fileURLWithPath: "/path/to/model.safetensors")
                try save(arrays: params.flattened(), url: url)
                """)

            Text("**모델 파라미터 로드:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN

                // 새 모델 인스턴스 생성
                let model = Linear(10, 2)

                // 저장된 파라미터 로드
                let url = URL(fileURLWithPath: "/path/to/model.safetensors")
                let loadedParams = try loadArrays(url: url)

                // 모델에 파라미터 적용
                try model.update(parameters: ModuleParameters.unflattened(loadedParams))
                """)

            Text("**체크포인트 저장:**")
                .font(.headline)
                .padding(.top, 8)

            CodeBlockView(code: """
                import MLX
                import MLXNN
                import MLXOptimizers

                // 학습 상태 저장
                func saveCheckpoint(
                    model: Module,
                    optimizer: Adam,
                    epoch: Int,
                    path: String
                ) throws {
                    var checkpoint: [String: MLXArray] = [:]

                    // 모델 파라미터
                    for (key, value) in model.parameters().flattened() {
                        checkpoint["model.\\(key)"] = value
                    }

                    // 에폭 번호
                    checkpoint["epoch"] = MLXArray(Int32(epoch))

                    let url = URL(fileURLWithPath: path)
                    try save(arrays: checkpoint, url: url)
                }

                // 학습 상태 로드
                func loadCheckpoint(
                    model: Module,
                    path: String
                ) throws -> Int {
                    let url = URL(fileURLWithPath: path)
                    let checkpoint = try loadArrays(url: url)

                    // 모델 파라미터 복원
                    var modelParams: [String: MLXArray] = [:]
                    for (key, value) in checkpoint {
                        if key.hasPrefix("model.") {
                            let paramKey = String(key.dropFirst(6))
                            modelParams[paramKey] = value
                        }
                    }
                    try model.update(
                        parameters: ModuleParameters.unflattened(modelParams)
                    )

                    // 에폭 복원
                    let epoch = checkpoint["epoch"]!.item(Int32.self)
                    return Int(epoch)
                }
                """)
        }
    }

    // MARK: - Run Section

    private var runSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Run Result", systemImage: "play.circle")
                .font(.title2.bold())

            HStack(spacing: 16) {
                Button(action: runExample) {
                    Label("Run", systemImage: "play.fill")
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
                    Text("Press the Run button to see results.")
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

            // 모델 생성
            result += "== 모델 파라미터 저장/로드 데모 ==\n\n"

            let model1 = Linear(4, 2)
            result += "1. 원본 모델 생성\n"
            result += "구조: Linear(4 -> 2)\n\n"

            // 원본 파라미터 확인
            let originalParams = model1.parameters()
            eval(originalParams)
            result += "원본 파라미터:\n"
            for (key, value) in originalParams.flattened() {
                result += "  \(key): shape=\(value.shape)\n"
            }

            // 테스트 입력으로 출력 확인
            let testInput = MLXArray.ones([1, 4])
            let originalOutput = model1(testInput)
            eval(originalOutput)
            result += "\n테스트 출력: \(originalOutput)\n\n"

            // 임시 파일에 저장
            let tempDir = FileManager.default.temporaryDirectory
            let savePath = tempDir.appendingPathComponent("test_model.safetensors")

            do {
                // 저장 - flattened()는 [(String, MLXArray)]를 반환하므로 딕셔너리로 변환
                let paramsDict = Dictionary(uniqueKeysWithValues: originalParams.flattened())
                try save(arrays: paramsDict, url: savePath)
                result += "2. 모델 저장됨: \(savePath.lastPathComponent)\n\n"

                // 새 모델 생성
                let model2 = Linear(4, 2)
                result += "3. 새 모델 생성\n"

                // 저장된 파라미터 확인 전
                let newOutput1 = model2(testInput)
                eval(newOutput1)
                result += "로드 전 출력: \(newOutput1)\n"

                // 파라미터 로드
                let loadedParams = try loadArrays(url: savePath)
                model2.update(parameters: ModuleParameters.unflattened(loadedParams))
                result += "4. 파라미터 로드됨\n\n"

                // 로드 후 출력 확인
                let newOutput2 = model2(testInput)
                eval(newOutput2)
                result += "로드 후 출력: \(newOutput2)\n\n"

                // 비교
                let diff = abs(originalOutput - newOutput2).sum()
                eval(diff)
                result += "원본과 차이: \(diff)\n"
                result += "→ 차이가 0이면 파라미터가 정확히 복원됨\n\n"

                // 정리
                try? FileManager.default.removeItem(at: savePath)

            } catch {
                result += "오류: \(error.localizedDescription)\n"
            }

            result += "== 지원 형식 ==\n"
            result += "• .safetensors - 권장 (안전, 빠름)\n"
            result += "• .npz - NumPy 호환\n"
            result += "• .gguf - LLM 모델용"

            await MainActor.run {
                output = result
                isRunning = false
            }
        }
    }
}

#Preview {
    Chapter9View()
        .frame(width: 800, height: 700)
}
