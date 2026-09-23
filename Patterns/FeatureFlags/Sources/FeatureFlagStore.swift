import Foundation
import Observation

/// Resolves every flag with a clear precedence:
/// **local override → remote value → default in code**.
///
/// It's `@Observable`, so views update when remote config arrives or a developer flips a switch.
@MainActor
@Observable
public final class FeatureFlagStore {
    private var remoteValues: [String: FlagValue] = [:]
    private var overrides: [String: FlagValue]

    private let source: any RemoteFlagSource
    private let userID: String
    private let defaults: UserDefaults
    private static let overridesKey = "feature_flag_overrides"

    public init(source: any RemoteFlagSource, userID: String, defaults: UserDefaults = .standard) {
        self.source = source
        self.userID = userID
        self.defaults = defaults
        overrides = defaults.data(forKey: Self.overridesKey)
            .flatMap { try? JSONDecoder().decode([String: FlagValue].self, from: $0) } ?? [:]
    }

    public subscript<Value>(_ flag: Flag<Value>) -> Value {
        let bucket = Rollout.bucket(for: "\(flag.key):\(userID)")
        for candidate in [overrides[flag.key], remoteValues[flag.key]] {
            // A value of the wrong type (e.g. a string for a Bool flag) is ignored, not a crash.
            if let candidate, let value = Value.decode(candidate, bucket: bucket) {
                return value
            }
        }
        return flag.defaultValue
    }

    /// Fetches remote values. On failure the last known values stay in place.
    public func refresh() async {
        do {
            remoteValues = try await source.fetchFlags()
        } catch {
            // Keep serving what we had. Flags should never take the app down.
        }
    }

    // MARK: - Local overrides (debug menu, QA)

    public func setOverride<Value>(_ value: Value?, for flag: Flag<Value>) {
        overrides[flag.key] = value?.flagValue
        saveOverrides()
    }

    public func isOverridden<Value>(_ flag: Flag<Value>) -> Bool {
        overrides[flag.key] != nil
    }

    public func resetOverrides() {
        overrides = [:]
        saveOverrides()
    }

    private func saveOverrides() {
        defaults.set(try? JSONEncoder().encode(overrides), forKey: Self.overridesKey)
    }
}
