#if canImport(UIKit)
import UIKit

extension UIListContentConfiguration {
    static func row(_ row: CoffeeRowDisplayModel) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = row.title
        content.secondaryText = row.subtitle
        content.secondaryTextProperties.color = .secondaryLabel
        return content
    }
}
#endif
