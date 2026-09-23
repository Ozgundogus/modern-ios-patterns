#if canImport(UIKit)
import BrewDomain
import UIKit

extension UIListContentConfiguration {
    public static func coffee(_ coffee: Coffee, isFavorite: Bool) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = isFavorite ? "\(coffee.name) ♥︎" : coffee.name
        content.secondaryText = "\(coffee.subtitle) · \(coffee.formattedPrice)"
        content.secondaryTextProperties.color = .secondaryLabel
        return content
    }
}
#endif
