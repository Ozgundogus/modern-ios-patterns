#if canImport(SwiftUI)
import SwiftUI

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
