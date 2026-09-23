import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class FavoritesViewModel {
    public private(set) var coffees: [Coffee] = []
    public private(set) var errorMessage: String?

    private let dependencies: BrewDependencies
    private let router: any FavoritesRouting

    public init(dependencies: BrewDependencies, router: any FavoritesRouting) {
        self.dependencies = dependencies
        self.router = router
    }

    public func load() async {
        do {
            coffees = try await dependencies.loadFavoriteCoffees()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func select(_ coffee: Coffee) {
        router.showDetail(for: coffee)
    }
}
