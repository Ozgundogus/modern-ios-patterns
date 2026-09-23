import Foundation
import Testing
@testable import Factory

struct ScreenLayoutDecodingTests {
    func decode(_ json: String) throws -> ScreenLayout {
        try JSONDecoder().decode(ScreenLayout.self, from: Data(json.utf8))
    }

    @Test func decodesEveryKnownComponent() throws {
        let layout = try decode("""
        {
            "title": "Today",
            "components": [
                { "type": "banner", "title": "Sale", "subtitle": "20% off", "style": "promo" },
                { "type": "product", "name": "Espresso", "price": 3, "badge": "NEW" },
                { "type": "button", "title": "Open", "url": "modernios://products" },
                { "type": "spacer", "height": 8 }
            ]
        }
        """)

        #expect(layout == ScreenLayout(title: "Today", components: [
            .banner(Banner(title: "Sale", subtitle: "20% off", style: .promo)),
            .product(ProductRow(name: "Espresso", price: 3, badge: "NEW")),
            .button(ActionButton(title: "Open", url: URL(string: "modernios://products")!)),
            .spacer(height: 8),
        ]))
    }

    @Test func keepsUnknownTypesAsUnsupported() throws {
        let layout = try decode("""
        { "title": "Today", "components": [ { "type": "video", "url": "https://example.com/a.mp4" } ] }
        """)

        #expect(layout.components == [.unsupported(type: "video")])
    }

    @Test func skipsMalformedComponentsAndKeepsTheRest() throws {
        let layout = try decode("""
        {
            "title": "Today",
            "components": [
                { "type": "banner", "subtitle": "no title" },
                { "type": "product", "name": "Espresso", "price": "not a number" },
                { "title": "no type" },
                { "type": "spacer", "height": 8 }
            ]
        }
        """)

        #expect(layout.components == [.spacer(height: 8)])
    }

    @Test func usesDefaultsForOptionalFields() throws {
        let layout = try decode("""
        {
            "title": "Today",
            "components": [
                { "type": "product", "name": "Espresso", "price": 3 },
                { "type": "banner", "title": "Hello" }
            ]
        }
        """)

        #expect(layout.components == [
            .product(ProductRow(name: "Espresso", price: 3)),
            .banner(Banner(title: "Hello")),
        ])
    }
}
