import Foundation
import Testing
@testable import MVVMCViewModels

struct DeepLinkTests {
    @Test(arguments: [
        ("brew://coffee/huila", DeepLink.coffee(id: "huila")),
        ("brew://coffee/huila/order", DeepLink.order(coffeeID: "huila")),
    ])
    func parsesKnownURLs(url: String, expected: DeepLink) throws {
        #expect(DeepLink(url: try #require(URL(string: url))) == expected)
    }

    @Test(arguments: ["https://coffee/huila", "brew://tea/sencha", "brew://coffee", "brew://coffee/huila/share"])
    func ignoresEverythingElse(url: String) throws {
        #expect(DeepLink(url: try #require(URL(string: url))) == nil)
    }
}
