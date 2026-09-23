import Foundation
import Observation

/// Resolves every flag in this order: local override → remote value → default in code.
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

    /// A stored value of the wrong type is ignored and the next source is used.
    public subscript<Value>(_ flag: Flag<Value>) -> Value {
        let bucket = Rollout.bucket(for: "\(flag.key):\(userID)")
        for candidate in [overrides[flag.key], remoteValues[flag.key]] {
            if let candidate, let value = Value.decode(candidate, bucket: bucket) {
                return value
            }
        }
        return flag.defaultValue
    }

    /// Fetches remote values. On failure the last known values stay in place.
    public func refresh() async {
        if let values = try? await source.fetchFlags() {
            remoteValues = values
        }
    }

    // MARK: - Local overrides

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
