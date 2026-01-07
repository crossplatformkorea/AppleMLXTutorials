import Foundation
import SwiftUI

/// Tutorial chapter model
struct Chapter: Identifiable, Hashable {
    let id: Int
    let titleKey: String
    let subtitleKey: String
    let icon: String
    let descriptionKey: String

    var title: String {
        String(localized: String.LocalizationValue(titleKey))
    }

    var subtitle: String {
        String(localized: String.LocalizationValue(subtitleKey))
    }

    var description: String {
        String(localized: String.LocalizationValue(descriptionKey))
    }

    static let allChapters: [Chapter] = [
        Chapter(
            id: 1,
            titleKey: "chapter.1.title",
            subtitleKey: "chapter.1.subtitle",
            icon: "sparkles",
            descriptionKey: "chapter.1.description"
        ),
        Chapter(
            id: 2,
            titleKey: "chapter.2.title",
            subtitleKey: "chapter.2.subtitle",
            icon: "square.grid.3x3",
            descriptionKey: "chapter.2.description"
        ),
        Chapter(
            id: 3,
            titleKey: "chapter.3.title",
            subtitleKey: "chapter.3.subtitle",
            icon: "function",
            descriptionKey: "chapter.3.description"
        ),
        Chapter(
            id: 4,
            titleKey: "chapter.4.title",
            subtitleKey: "chapter.4.subtitle",
            icon: "cpu",
            descriptionKey: "chapter.4.description"
        ),
        Chapter(
            id: 5,
            titleKey: "chapter.5.title",
            subtitleKey: "chapter.5.subtitle",
            icon: "chart.line.uptrend.xyaxis",
            descriptionKey: "chapter.5.description"
        ),
        Chapter(
            id: 6,
            titleKey: "chapter.6.title",
            subtitleKey: "chapter.6.subtitle",
            icon: "brain",
            descriptionKey: "chapter.6.description"
        ),
        Chapter(
            id: 7,
            titleKey: "chapter.7.title",
            subtitleKey: "chapter.7.subtitle",
            icon: "waveform.path.ecg",
            descriptionKey: "chapter.7.description"
        ),
        Chapter(
            id: 8,
            titleKey: "chapter.8.title",
            subtitleKey: "chapter.8.subtitle",
            icon: "dial.low",
            descriptionKey: "chapter.8.description"
        ),
        Chapter(
            id: 9,
            titleKey: "chapter.9.title",
            subtitleKey: "chapter.9.subtitle",
            icon: "arrow.down.doc",
            descriptionKey: "chapter.9.description"
        ),
        Chapter(
            id: 10,
            titleKey: "chapter.10.title",
            subtitleKey: "chapter.10.subtitle",
            icon: "number",
            descriptionKey: "chapter.10.description"
        ),
        Chapter(
            id: 11,
            titleKey: "chapter.11.title",
            subtitleKey: "chapter.11.subtitle",
            icon: "text.bubble",
            descriptionKey: "chapter.11.description"
        ),
        Chapter(
            id: 12,
            titleKey: "chapter.12.title",
            subtitleKey: "chapter.12.subtitle",
            icon: "eye",
            descriptionKey: "chapter.12.description"
        ),
        Chapter(
            id: 13,
            titleKey: "chapter.13.title",
            subtitleKey: "chapter.13.subtitle",
            icon: "slider.horizontal.3",
            descriptionKey: "chapter.13.description"
        ),
        Chapter(
            id: 14,
            titleKey: "chapter.14.title",
            subtitleKey: "chapter.14.subtitle",
            icon: "photo.artframe",
            descriptionKey: "chapter.14.description"
        ),
        Chapter(
            id: 15,
            titleKey: "chapter.15.title",
            subtitleKey: "chapter.15.subtitle",
            icon: "apple.logo",
            descriptionKey: "chapter.15.description"
        )
    ]
}
