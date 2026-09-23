import BrewData
import BrewDomain
import Testing
@testable import VIPER

@MainActor
struct CatalogPresenterTests {
    let view = SpyCatalogView()
    let router = SpyRouter()

    func makePresenter(_ dependencies: BrewDependencies = .test()) -> CatalogPresenter {
        let presenter = CatalogPresenter(interactor: CatalogInteractor(dependencies: dependencies), router: router)
        presenter.view = view
        return presenter
    }

    @Test func displaysFormattedRowsOnAppear() async {
        let presenter = makePresenter(.test(favorites: InMemoryFavoritesRepository(["huila"])))

        await presenter.viewWillAppear()

        #expect(view.displayed.last?.rows.map(\.id) == ["huila", "sumatra", "yirgacheffe"])
        #expect(view.displayed.last?.rows.first?.title == "Huila ♥︎")
    }

    @Test func filtersByQueryAndRoast() async {
        let presenter = makePresenter()

        await presenter.didChangeQuery("ethiopia")
        #expect(view.displayed.last?.rows.map(\.id) == ["yirgacheffe"])

        await presenter.didChangeQuery("")
        await presenter.didSelectRoast(.dark)
        #expect(view.displayed.last?.rows.map(\.id) == ["sumatra"])
    }

    @Test func selectingARowAsksTheRouterToNavigate() async {
        let presenter = makePresenter()
        await presenter.viewWillAppear()

        presenter.didSelectCoffee(id: "sumatra")

        #expect(router.shownDetails == [Coffee.samples[2]])
    }

    @Test func failedRefreshKeepsRowsAndShowsAMessage() async {
        let coffees = InMemoryCoffeeRepository()
        let presenter = makePresenter(.test(coffees: coffees))
        await presenter.viewWillAppear()
        await coffees.setReachable(false)

        await presenter.didPullToRefresh()

        #expect(view.displayed.last?.rows.count == 3)
        #expect(view.displayed.last?.offlineMessage == CoffeeError.unavailable.errorDescription)
    }
}
