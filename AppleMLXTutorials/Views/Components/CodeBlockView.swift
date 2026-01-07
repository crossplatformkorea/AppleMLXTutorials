import SwiftUI

/// 코드 블록을 표시하고 복사 기능을 제공하는 컴포넌트
struct CodeBlockView: View {
    let code: String
    @State private var copied = false

    var body: some View {
        GroupBox {
            VStack(spacing: 0) {
                // 복사 버튼 헤더
                HStack {
                    Spacer()
                    Button(action: copyCode) {
                        HStack(spacing: 4) {
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            Text(copied ? "복사됨" : "복사")
                                .font(.caption)
                        }
                        .foregroundStyle(copied ? .green : .secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)

                // 코드 내용
                ScrollView(.horizontal) {
                    Text(code)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                }
            }
        }
    }

    private func copyCode() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        #else
        UIPasteboard.general.string = code
        #endif
        copied = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copied = false
        }
    }
}

#Preview {
    CodeBlockView(code: """
    import MLX

    let a = MLXArray([1, 2, 3, 4])
    let b = MLXArray([5, 6, 7, 8])
    let c = a + b
    print(c)
    """)
    .padding()
    .frame(width: 600)
}
