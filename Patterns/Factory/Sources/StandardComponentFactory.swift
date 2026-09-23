#if canImport(SwiftUI)
import SwiftUI

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
#endif
