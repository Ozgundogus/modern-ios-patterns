import BrewData
import BrewDomain
import Testing
@testable import MVVM

@MainActor
struct CatalogViewModelTests {
    @Test func loadsTheCatalogSortedByName() async {
        let viewModel = CatalogViewModel(dependencies: .test())

        await viewModel.load()

        #expect(viewModel.coffees.map(\.name) == ["Huila", "Sumatra Mandheling", "Yirgacheffe"])
        #expect(!viewModel.isLoading)
    }

    @Test func filtersByQueryAndRoast() async {
        let viewModel = CatalogViewModel(dependencies: .test())

        viewModel.query = "ethiopia"
        await viewModel.load()
        #expect(viewModel.coffees.map(\.id) == ["yirgacheffe"])

        viewModel.query = ""
        viewModel.roast = .dark
        await viewModel.load()
        #expect(viewModel.coffees.map(\.id) == ["sumatra"])
    }

    @Test func marksFavorites() async {
        let viewModel = CatalogViewModel(dependencies: .test(favorites: InMemoryFavoritesRepository(["huila"])))

        await viewModel.load()

        #expect(viewModel.isFavorite(Coffee.samples[1]))
        #expect(!viewModel.isFavorite(Coffee.samples[0]))
    }

    @Test func failedRefreshKeepsTheListAndShowsAMessage() async {
        let coffees = InMemoryCoffeeRepository()
        let viewModel = CatalogViewModel(dependencies: .test(coffees: coffees))
        await viewModel.load()
        await coffees.setReachable(false)

        await viewModel.refresh()

        #expect(viewModel.coffees.count == 3)
        #expect(viewModel.offlineMessage == CoffeeError.unavailable.errorDescription)
    }

    @Test func successfulRefreshClearsTheMessage() async {
        let coffees = InMemoryCoffeeRepository()
        let viewModel = CatalogViewModel(dependencies: .test(coffees: coffees))
        await coffees.setReachable(false)
        await viewModel.refresh()

        await coffees.setReachable(true)
        await viewModel.refresh()

        #expect(viewModel.offlineMessage == nil)
    }
}
