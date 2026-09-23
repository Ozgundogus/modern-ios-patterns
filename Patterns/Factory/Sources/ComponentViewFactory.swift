#if canImport(SwiftUI)
import SwiftUI

/// Turns a `Component` into a view. The screen only knows this protocol,
/// so a different factory can render the same data in a completely different style.
@MainActor
public protocol ComponentViewFactory {
    associatedtype Content: View
    @ViewBuilder func makeView(for component: Component) -> Content
}
#endif
