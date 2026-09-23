import Testing
@testable import Singleton

@MainActor
struct ReaderViewModelTests {
    @Test func usesTheInjectedSettings() {
        let settings = SettingsStore(defaults: .isolated())
        let reader = ReaderViewModel(settings: settings, wordCount: 1_000)
        #expect(reader.fontSize == 17)
        #expect(reader.minutesToRead == 5)

        settings.setPrefersLargeText(true)
        settings.setReadingSpeed(2)

        #expect(reader.fontSize == 22)
        #expect(reader.minutesToRead == 3)
    }
}
