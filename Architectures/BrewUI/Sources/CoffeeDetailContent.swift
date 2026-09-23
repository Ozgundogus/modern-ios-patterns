#if canImport(SwiftUI)
import BrewDomain
import SwiftUI

public struct CoffeeDetailContent: View {
    private let coffee: Coffee
    private let isFavorite: Bool
    private let onToggleFavorite: () -> Void

    public init(coffee: Coffee, isFavorite: Bool, onToggleFavorite: @escaping () -> Void) {
        self.coffee = coffee
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }

    public var body: some View {
        Form {
            Section {
                Text(coffee.summary)
            }
            Section {
                LabeledContent("Origin", value: coffee.origin)
                LabeledContent("Roast", value: coffee.roast.displayName)
                LabeledContent("Tasting notes", value: coffee.notesText)
                LabeledContent("Price", value: coffee.formattedPrice)
            }
            Section {
                Button(action: onToggleFavorite) {
                    Label(
                        isFavorite ? "Remove from favorites" : "Add to favorites",
                        systemImage: isFavorite ? "heart.slash" : "heart"
                    )
                }
            }
        }
        .navigationTitle(coffee.name)
    }
}
#endif
