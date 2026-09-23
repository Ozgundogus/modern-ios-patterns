import Observation

/// Depends on a `SettingsStore` it is given, not on `SettingsStore.shared`,
/// so tests can pass an isolated instance.
@MainActor
@Observable
public final class ReaderViewModel {
    private let settings: SettingsStore
    private let wordCount: Int

    public init(settings: SettingsStore, wordCount: Int) {
        self.settings = settings
        self.wordCount = wordCount
    }

    public var fontSize: Double {
        settings.prefersLargeText ? 22 : 17
    }

    public var minutesToRead: Int {
        let wordsPerMinute = 200 * settings.readingSpeed
        return max(1, Int((Double(wordCount) / wordsPerMinute).rounded(.up)))
    }
}
