import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class FavoritesViewModel {
    public private(set) var coffees: [Coffee] = []
    public private(set) var errorMessage: String?

    private let dependencies: BrewDependencies

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
    }

    public func load() async {
        do {
            coffees = try await dependencies.loadFavoriteCoffees()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func makeDetailViewModel(for coffee: Coffee) -> CoffeeDetailViewModel {
        CoffeeDetailViewModel(coffee: coffee, dependencies: dependencies)
    }
}
