import BrewData
import BrewDomain
import Testing
@testable import MVVMCViewModels

@MainActor
struct CoffeeDetailViewModelTests {
    @Test func togglingAFavoriteTellsTheCoordinator() async {
        let viewModel = CoffeeDetailViewModel(coffee: Coffee.samples[0], dependencies: .test())
        var changes = 0
        viewModel.onFavoriteChanged = { changes += 1 }

        await viewModel.toggleFavorite()

        #expect(viewModel.isFavorite)
        #expect(changes == 1)
    }

    @Test func orderingReportsTheCoffeeWithoutNavigating() {
        let viewModel = CoffeeDetailViewModel(coffee: Coffee.samples[1], dependencies: .test())
        var ordered: [Coffee] = []
        viewModel.onOrder = { ordered.append($0) }

        viewModel.order()

        #expect(ordered == [Coffee.samples[1]])
    }
}
