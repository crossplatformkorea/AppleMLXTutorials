import SwiftUI

struct SidebarView: View {
    @Binding var selectedChapter: Chapter?

    var body: some View {
        List(Chapter.allChapters, selection: $selectedChapter) { chapter in
            NavigationLink(value: chapter) {
                HStack(spacing: 12) {
                    Image(systemName: chapter.icon)
                        .font(.title2)
                        .foregroundStyle(.tint)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Chapter \(chapter.id)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(chapter.title)
                            .font(.headline)

                        Text(chapter.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("MLX Swift")
        .navigationSubtitle("Machine Learning Tutorial")
    }
}

#Preview {
    SidebarView(selectedChapter: .constant(Chapter.allChapters.first))
        .frame(width: 300)
}
