import BrewDomain
import Observation

/// One router per tab. Each screen sees it only through its own small routing protocol,
/// so the same screen can navigate differently depending on where it is shown.
@MainActor
@Observable
public final class TabRouter: CatalogRouting, FavoritesRouting, DetailRouting {
    public var path: [Route] = []

    private let popsWhenFavoriteIsRemoved: Bool

    public init(popsWhenFavoriteIsRemoved: Bool = false) {
        self.popsWhenFavoriteIsRemoved = popsWhenFavoriteIsRemoved
    }

    public func showDetail(for coffee: Coffee) {
        path.append(.detail(coffee))
    }

    public func didRemoveFavorite(_ coffee: Coffee) {
        guard popsWhenFavoriteIsRemoved else { return }
        path.removeAll { $0 == .detail(coffee) }
    }
}
