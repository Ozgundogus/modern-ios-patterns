#if canImport(UIKit)
import Observation

/// Runs `apply` now and again every time an `@Observable` property it read changes.
/// This is how UIKit screens on iOS 17 follow the same view models SwiftUI views observe.
@MainActor
func observe(_ apply: @escaping @MainActor @Sendable () -> Void) {
    withObservationTracking {
        apply()
    } onChange: {
        Task { @MainActor in
            observe(apply)
        }
    }
}
#endif
