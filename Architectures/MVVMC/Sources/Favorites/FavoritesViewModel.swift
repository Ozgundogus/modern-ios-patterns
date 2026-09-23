import BrewData
import BrewDomain
import Observation

@MainActor
@Observable
public final class FavoritesViewModel {
    public private(set) var coffees: [Coffee] = []
    public private(set) var errorMessage: String?

    @ObservationIgnored public var onSelect: ((Coffee) -> Void)?

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

    public func select(_ coffee: Coffee) {
        onSelect?(coffee)
    }
}
