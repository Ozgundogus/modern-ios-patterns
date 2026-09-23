import BrewDomain
import Testing
@testable import Clean

@MainActor
struct CatalogViewModelTests {
    @Test func producesFormattedRows() async {
        let ports = StubPorts(favorites: ["huila"])
        let viewModel = CatalogViewModel(catalog: ports, favorites: ports)
        viewModel.query = "colombia"

        await viewModel.load()

        #expect(viewModel.rows == [CoffeeRowViewData(coffee: Coffee.samples[1], isFavorite: true)])
        #expect(viewModel.rows.first?.subtitle == "Colombia · Medium roast")
        #expect(ports.searches == ["colombia"])
    }

    @Test func failedRefreshKeepsRowsAndShowsAMessage() async {
        let ports = StubPorts(refreshError: CoffeeError.unavailable)
        let viewModel = CatalogViewModel(catalog: ports, favorites: ports)
        await viewModel.load()

        await viewModel.refresh()

        #expect(viewModel.rows.count == 3)
        #expect(viewModel.offlineMessage == CoffeeError.unavailable.errorDescription)
    }
}
