import BrewData
import BrewDomain

public struct FavoritesInteractor: FavoritesInteracting {
    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public func favoriteCoffees() async throws -> [Coffee] {
        try await dependencies.loadFavoriteCoffees()
    }
}
