import SwiftUI
import AppKit

struct ChapterDetailView: View {
    let chapter: Chapter
    @State private var isHovering = false
    @State private var showCopied = false

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            chapterHeader

            Divider()

            // Chapter content
            chapterContent
        }
        .navigationTitle("")
    }

    // MARK: - Chapter Header

    private var chapterHeader: some View {
        HStack(spacing: 12) {
            Text("Chapter \(chapter.id): \(chapter.title)")
                .font(.title.bold())

            // Copy button (shown only on hover)
            if isHovering || showCopied {
                Button(action: copyChapterCode) {
                    HStack(spacing: 4) {
                        Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                        Text(showCopied ? "Copied" : "Copy")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(showCopied ? Color.green.opacity(0.2) : Color.secondary.opacity(0.1))
                    .foregroundStyle(showCopied ? .green : .secondary)
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(nsColor: .windowBackgroundColor))
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }

    // MARK: - Chapter Content

    private var chapterContent: some View {
        Group {
            switch chapter.id {
            case 1:
                Chapter1View()
            case 2:
                Chapter2View()
            case 3:
                Chapter3View()
            case 4:
                Chapter4View()
            case 5:
                Chapter5View()
            case 6:
                Chapter6View()
            case 7:
                Chapter7View()
            case 8:
                Chapter8View()
            case 9:
                Chapter9View()
            case 10:
                Chapter10View()
            case 11:
                Chapter11View()
            case 12:
                Chapter12View()
            case 13:
                Chapter13View()
            case 14:
                Chapter14View()
            case 15:
                Chapter15View()
            default:
                ContentUnavailableView(
                    "Coming Soon",
                    systemImage: "hammer",
                    description: Text("This chapter is under development.")
                )
            }
        }
    }

    // MARK: - Actions

    private func copyChapterCode() {
        let code = ChapterContent.getCode(for: chapter.id)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)

        withAnimation(.easeInOut(duration: 0.2)) {
            showCopied = true
        }

        // Hide copied indicator after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }
}

#Preview {
    ChapterDetailView(chapter: Chapter.allChapters[0])
}
