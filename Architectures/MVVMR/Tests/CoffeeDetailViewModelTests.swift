import BrewData
import BrewDomain
import Testing
@testable import MVVMR

@MainActor
struct CoffeeDetailViewModelTests {
    @Test func removingAFavoriteTellsTheRouter() async {
        let router = SpyRouter()
        let viewModel = CoffeeDetailViewModel(
            coffee: Coffee.samples[1],
            dependencies: .test(favorites: InMemoryFavoritesRepository(["huila"])),
            router: router
        )
        await viewModel.load()

        await viewModel.toggleFavorite()

        #expect(!viewModel.isFavorite)
        #expect(router.removedFavorites == [Coffee.samples[1]])
    }

    @Test func addingAFavoriteDoesNotNavigate() async {
        let router = SpyRouter()
        let viewModel = CoffeeDetailViewModel(coffee: Coffee.samples[1], dependencies: .test(), router: router)

        await viewModel.toggleFavorite()

        #expect(viewModel.isFavorite)
        #expect(router.removedFavorites.isEmpty)
    }
}
