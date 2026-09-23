import Foundation
import Testing
@testable import BrewDomain

struct OrderTests {
    @Test func totalScalesWithSizeAndQuantity() {
        let huila = Coffee.samples[1]

        #expect(Order(coffee: huila).total == 14)
        #expect(Order(coffee: huila, size: .medium).total == 28)
        #expect(Order(coffee: huila, size: .large, quantity: 3).total == 168)
    }

    @Test func sizesReadLikeBagLabels() {
        #expect(Order.Size.allCases.map(\.displayName) == ["250 g", "500 g", "1 kg"])
    }
}
