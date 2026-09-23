import Foundation
@testable import BrewData

extension CoffeeDTO {
    static let huila = CoffeeDTO(
        id: "huila",
        name: "Huila",
        origin: "Colombia",
        roast: "medium",
        tastingNotes: ["Caramel"],
        priceUSD: "14.50",
        summary: "Sweet and balanced."
    )

    func with(roast: String? = nil, priceUSD: String? = nil) -> CoffeeDTO {
        CoffeeDTO(
            id: id,
            name: name,
            origin: origin,
            roast: roast ?? self.roast,
            tastingNotes: tastingNotes,
            priceUSD: priceUSD ?? self.priceUSD,
            summary: summary
        )
    }
}
