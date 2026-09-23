import BrewData
import BrewDomain
import Testing
@testable import VIPER

@MainActor
struct FavoritesPresenterTests {
    @Test func listsFavoritesAndRoutesToTheDetail() async {
        let router = SpyRouter()
        let presenter = FavoritesPresenter(
            interactor: FavoritesInteractor(dependencies: .test(favorites: InMemoryFavoritesRepository(["sumatra"]))),
            router: router
        )

        await presenter.viewWillAppear()
        presenter.didSelectCoffee(id: "sumatra")

        #expect(router.shownDetails == [Coffee.samples[2]])
    }
}
