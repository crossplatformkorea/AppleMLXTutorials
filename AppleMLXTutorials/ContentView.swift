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
                        "Select a Chapter",
                        systemImage: "book.closed",
                        description: Text("Select a chapter from the sidebar to start learning.")
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)

            HStack {
                Spacer()
                Text("by ")
                    .foregroundStyle(.secondary)
                +
                Text("Cross-Platform Korea")
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
