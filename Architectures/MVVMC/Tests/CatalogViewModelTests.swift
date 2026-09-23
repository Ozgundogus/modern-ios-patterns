import BrewData
import BrewDomain
import Testing
@testable import MVVMC

@MainActor
struct CatalogViewModelTests {
    @Test func reportsSelectionWithoutNavigating() {
        let viewModel = CatalogViewModel(dependencies: .test())
        var selected: [Coffee] = []
        viewModel.onSelect = { selected.append($0) }

        viewModel.select(Coffee.samples[0])

        #expect(selected == [Coffee.samples[0]])
    }

    @Test func failedRefreshKeepsTheListAndShowsAMessage() async {
        let coffees = InMemoryCoffeeRepository()
        let viewModel = CatalogViewModel(dependencies: .test(coffees: coffees))
        await viewModel.load()
        await coffees.setReachable(false)

        await viewModel.refresh()

        #expect(viewModel.coffees.count == 3)
        #expect(viewModel.offlineMessage != nil)
    }
}
