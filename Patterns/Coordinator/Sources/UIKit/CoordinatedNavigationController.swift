#if canImport(UIKit)
import UIKit

/// Holds a strong reference to the coordinator for as long as the flow is on screen.
final class CoordinatedNavigationController: UINavigationController {
    var coordinator: UIKitShopCoordinator?
}
#endif
