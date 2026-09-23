import BrewData
import BrewDomain
import Testing
@testable import MVVM

@MainActor
struct CoffeeDetailViewModelTests {
    @Test func togglesTheFavorite() async {
        let favorites = InMemoryFavoritesRepository()
        let viewModel = CoffeeDetailViewModel(coffee: Coffee.samples[0], dependencies: .test(favorites: favorites))
        await viewModel.load()
        #expect(!viewModel.isFavorite)

        await viewModel.toggleFavorite()

        #expect(viewModel.isFavorite)
        #expect(await favorites.favoriteIDs() == ["yirgacheffe"])
    }
}
