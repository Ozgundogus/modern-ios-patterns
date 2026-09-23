import Foundation
import Testing
@testable import Singleton

@MainActor
struct SettingsStoreTests {
    @Test func startsWithDefaults() {
        let settings = SettingsStore(defaults: .isolated())

        #expect(settings.prefersLargeText == false)
        #expect(settings.readingSpeed == 1)
    }

    @Test func persistsAcrossInstances() {
        let defaults = UserDefaults.isolated()
        SettingsStore(defaults: defaults).setPrefersLargeText(true)

        let relaunched = SettingsStore(defaults: defaults)

        #expect(relaunched.prefersLargeText)
    }

    @Test func instancesDoNotShareState() {
        let first = SettingsStore(defaults: .isolated())
        let second = SettingsStore(defaults: .isolated())

        first.setReadingSpeed(2)

        #expect(second.readingSpeed == 1)
    }

    @Test func readingSpeedIsClamped() {
        let settings = SettingsStore(defaults: .isolated())

        settings.setReadingSpeed(10)
        #expect(settings.readingSpeed == 2)

        settings.setReadingSpeed(0)
        #expect(settings.readingSpeed == 0.5)
    }

    @Test func sharedIsASingleInstance() {
        #expect(SettingsStore.shared === SettingsStore.shared)
    }
}
