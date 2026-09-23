import BrewData
import BrewDomain
import Testing
@testable import MVVMR

@MainActor
struct CatalogViewModelTests {
    @Test func selectionGoesThroughTheRouter() {
        let router = SpyRouter()
        let viewModel = CatalogViewModel(dependencies: .test(), router: router)

        viewModel.select(Coffee.samples[0])

        #expect(router.shownDetails == [Coffee.samples[0]])
    }

    @Test func filtersByQueryAndRoast() async {
        let viewModel = CatalogViewModel(dependencies: .test(), router: SpyRouter())

        viewModel.roast = .light
        await viewModel.load()

        #expect(viewModel.coffees.map(\.id) == ["yirgacheffe"])
    }
}
