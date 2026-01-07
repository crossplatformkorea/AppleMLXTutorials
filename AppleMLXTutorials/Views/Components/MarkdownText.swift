import SwiftUI

/// 마크다운 텍스트를 렌더링하는 뷰
struct MarkdownText: View {
    let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        Group {
            if let attributedString = try? AttributedString(markdown: content, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
                Text(attributedString)
            } else {
                Text(content)
            }
        }
    }
}

#Preview {
    MarkdownText("""
    # Heading 1
    ## Heading 2
    ### Heading 3

    This is **bold** and *italic* text.

    - Item 1
    - Item 2
    - Item 3

    1. First
    2. Second
    3. Third

    `inline code`

    > Blockquote
    """)
    .padding()
}
