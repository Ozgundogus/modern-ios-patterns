import BrewData
import BrewDomain
import Testing
@testable import MVVM

@MainActor
struct FavoritesViewModelTests {
    @Test func showsFavoritesAfterTheyChange() async {
        let dependencies = BrewDependencies.test()
        let favorites = FavoritesViewModel(dependencies: dependencies)
        await favorites.load()
        #expect(favorites.coffees.isEmpty)

        let detail = favorites.makeDetailViewModel(for: Coffee.samples[2])
        await detail.toggleFavorite()
        await favorites.load()

        #expect(favorites.coffees.map(\.id) == ["sumatra"])
    }
}
