import BrewDomain
import Testing
@testable import Clean

@MainActor
struct CoffeeDetailViewModelTests {
    @Test func loadsAndFormatsTheCoffee() async {
        let ports = StubPorts()
        let viewModel = CoffeeDetailViewModel(coffeeID: "sumatra", loader: ports, favorites: ports, toggler: ports)

        await viewModel.load()

        #expect(viewModel.viewData?.title == "Sumatra Mandheling")
        #expect(viewModel.viewData?.facts.map(\.label) == ["Origin", "Roast", "Tasting notes", "Price"])
        #expect(viewModel.viewData?.favoriteButtonTitle == "Add to favorites")
    }

    @Test func togglingUpdatesTheViewData() async {
        let ports = StubPorts()
        let viewModel = CoffeeDetailViewModel(coffeeID: "sumatra", loader: ports, favorites: ports, toggler: ports)
        await viewModel.load()

        await viewModel.toggleFavorite()

        #expect(viewModel.viewData?.isFavorite == true)
        #expect(viewModel.viewData?.favoriteButtonTitle == "Remove from favorites")
    }

    @Test func unknownCoffeeShowsAnError() async {
        let ports = StubPorts()
        let viewModel = CoffeeDetailViewModel(coffeeID: "decaf", loader: ports, favorites: ports, toggler: ports)

        await viewModel.load()

        #expect(viewModel.viewData == nil)
        #expect(viewModel.errorMessage == CoffeeError.notFound(id: "decaf").errorDescription)
    }
}
