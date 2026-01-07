import SwiftUI

struct ContentView: View {
    @State private var selectedChapter: Chapter? = Chapter.allChapters.first

    var body: some View {
        VStack(spacing: 0) {
            NavigationSplitView {
                SidebarView(selectedChapter: $selectedChapter)
            } detail: {
                if let chapter = selectedChapter {
                    ChapterDetailView(chapter: chapter)
                } else {
                    ContentUnavailableView(
                        "챕터를 선택하세요",
                        systemImage: "book.closed",
                        description: Text("왼쪽 사이드바에서 학습할 챕터를 선택해주세요.")
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)

            HStack {
                Spacer()
                Text("by ")
                    .foregroundStyle(.secondary)
                +
                Text("크로스플랫폼 코리아")
                    .foregroundStyle(.blue)
            }
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.bar)
            .onTapGesture {
                #if os(macOS)
                if let url = URL(string: "https://www.youtube.com/@crossplatformkorea") {
                    NSWorkspace.shared.open(url)
                }
                #endif
            }
        }
    }
}

#Preview {
    ContentView()
}
