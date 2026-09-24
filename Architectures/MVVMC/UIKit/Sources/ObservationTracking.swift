#if canImport(UIKit)
import Observation

/// Runs `apply` now and again every time an `@Observable` property it read changes.
/// This is how UIKit screens follow the same view models SwiftUI views observe, without relying on UIKit's own observation tracking.
@MainActor
func startObserving(_ apply: @escaping @MainActor @Sendable () -> Void) {
    withObservationTracking {
        apply()
    } onChange: {
        Task { @MainActor in
            startObserving(apply)
        }
    }
}
#endif
