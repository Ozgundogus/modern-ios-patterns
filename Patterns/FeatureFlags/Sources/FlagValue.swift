public enum FlagValue: Sendable, Equatable {
    case bool(Bool)
    case int(Int)
    case string(String)
    /// Enabled for this percentage of users (0...100). Only meaningful for `Bool` flags.
    case rollout(percentage: Int)
}
