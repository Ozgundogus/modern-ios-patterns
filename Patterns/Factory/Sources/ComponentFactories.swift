#if canImport(SwiftUI)
import SwiftUI

/// Turns a `Component` into a view. The screen only knows this protocol,
/// so a different factory can render the same data in a completely different style.
@MainActor
public protocol ComponentViewFactory {
    associatedtype Content: View
    @ViewBuilder func makeView(for component: Component) -> Content
}

public struct StandardComponentFactory: ComponentViewFactory {
    private let onOpenURL: (URL) -> Void

    public init(onOpenURL: @escaping (URL) -> Void = { _ in }) {
        self.onOpenURL = onOpenURL
    }

    @ViewBuilder
    public func makeView(for component: Component) -> some View {
        switch component {
        case .banner(let banner):
            VStack(alignment: .leading, spacing: 4) {
                Text(banner.title).font(.headline)
                if let subtitle = banner.subtitle {
                    Text(subtitle).font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(banner.style == .promo ? Color.orange.opacity(0.2) : Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        case .product(let product):
            HStack {
                Text(product.name)
                if let badge = product.badge {
                    Text(badge).font(.caption.bold()).padding(4).background(.yellow).clipShape(Capsule())
                }
                Spacer()
                Text(product.price, format: .currency(code: "USD")).foregroundStyle(.secondary)
            }
        case .button(let button):
            Button(button.title) { onOpenURL(button.url) }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
        case .spacer(let height):
            Color.clear.frame(height: height)
        case .unsupported:
            EmptyView()
        }
    }
}

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

public struct ServerDrivenScreen<Factory: ComponentViewFactory>: View {
    private let layout: ScreenLayout
    private let factory: Factory

    public init(layout: ScreenLayout, factory: Factory) {
        self.layout = layout
        self.factory = factory
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(layout.components.enumerated()), id: \.offset) { _, component in
                    factory.makeView(for: component)
                }
            }
            .padding()
        }
        .navigationTitle(layout.title)
    }
}

// MARK: - Previews

extension ScreenLayout {
    static let sample: ScreenLayout = {
        let json = Data("""
        {
            "title": "Today",
            "components": [
                { "type": "banner", "title": "Autumn sale", "subtitle": "20% off all coffee", "style": "promo" },
                { "type": "product", "name": "Espresso", "price": 3 },
                { "type": "product", "name": "Pumpkin Latte", "price": 5.5, "badge": "NEW" },
                { "type": "spacer", "height": 8 },
                { "type": "video", "url": "https://example.com/promo.mp4" },
                { "type": "banner", "subtitle": "missing title, skipped" },
                { "type": "button", "title": "See all products", "url": "modernios://products" }
            ]
        }
        """.utf8)
        return (try? JSONDecoder().decode(ScreenLayout.self, from: json)) ?? ScreenLayout(title: "Error", components: [])
    }()
}

#Preview("Standard factory") {
    NavigationStack {
        ServerDrivenScreen(layout: .sample, factory: StandardComponentFactory())
    }
}

#Preview("Debug factory") {
    NavigationStack {
        ServerDrivenScreen(layout: .sample, factory: DebugComponentFactory())
    }
}
#endif
