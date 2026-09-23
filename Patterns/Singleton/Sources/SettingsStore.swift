import Foundation
import Observation

/// A shared instance done the Swift 6 way:
/// - `@MainActor` isolation makes `shared` safe to touch from anywhere without locks.
/// - A public initializer means tests and previews never have to use `shared`.
@MainActor
@Observable
public final class SettingsStore {
    public static let shared = SettingsStore(defaults: .standard)

    public private(set) var prefersLargeText: Bool
    public private(set) var readingSpeed: Double

    private let defaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.defaults = defaults
        prefersLargeText = defaults.bool(forKey: Keys.prefersLargeText)
        readingSpeed = defaults.object(forKey: Keys.readingSpeed) as? Double ?? 1
    }

    public func setPrefersLargeText(_ value: Bool) {
        prefersLargeText = value
        defaults.set(value, forKey: Keys.prefersLargeText)
    }

    public func setReadingSpeed(_ value: Double) {
        readingSpeed = min(max(value, 0.5), 2)
        defaults.set(readingSpeed, forKey: Keys.readingSpeed)
    }

    public func reset() {
        defaults.removeObject(forKey: Keys.prefersLargeText)
        defaults.removeObject(forKey: Keys.readingSpeed)
        prefersLargeText = false
        readingSpeed = 1
    }

    private enum Keys {
        static let prefersLargeText = "settings.prefersLargeText"
        static let readingSpeed = "settings.readingSpeed"
    }
}
