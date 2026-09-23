import Foundation
import Testing
@testable import Coordinator

struct DeepLinkTests {
    @Test(arguments: [
        ("modernios://product/2", 2),
        ("modernios://product/abc", nil),
        ("modernios://settings/2", nil),
        ("https://product/2", nil),
    ] as [(String, Int?)])
    func parsesProductLinks(link: String, expected: Int?) throws {
        let url = try #require(URL(string: link))
        #expect(DeepLink.productID(from: url) == expected)
    }
}
