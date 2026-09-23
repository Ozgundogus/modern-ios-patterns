#if canImport(SwiftUI)
import BrewDomain
import SwiftUI

public struct CoffeeRow: View {
    private let coffee: Coffee
    private let isFavorite: Bool

    public init(coffee: Coffee, isFavorite: Bool) {
        self.coffee = coffee
        self.isFavorite = isFavorite
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(coffee.name).font(.headline)
                Text(coffee.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            if isFavorite {
                Image(systemName: "heart.fill").foregroundStyle(.pink)
            }
            Text(coffee.formattedPrice).monospacedDigit()
        }
    }
}
#endif
