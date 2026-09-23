#if canImport(SwiftUI)
import SwiftUI

/// Same components, rendered for internal builds: every block is outlined and labeled,
/// and unsupported types are visible instead of silently hidden.
public struct DebugComponentFactory: ComponentViewFactory {
    private let base = StandardComponentFactory()

    public init() {}

    public func makeView(for component: Component) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(component.debugName).font(.caption2.monospaced()).foregroundStyle(.red)
            if case .unsupported(let type) = component {
                Text("Unsupported component: \(type)").font(.caption).foregroundStyle(.red)
            } else {
                base.makeView(for: component)
            }
        }
        .padding(4)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(.red.opacity(0.5), style: StrokeStyle(dash: [4])))
    }
}

extension Component {
    var debugName: String {
        switch self {
        case .banner: "banner"
        case .product: "product"
        case .button: "button"
        case .spacer: "spacer"
        case .unsupported(let type): type
        }
    }
}
#endif
