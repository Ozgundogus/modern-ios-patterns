import Foundation

public enum Roast: String, Sendable, CaseIterable, Identifiable {
    case light
    case medium
    case dark

    public var id: String { rawValue }

    public var displayName: String {
        rawValue.capitalized
    }
}
