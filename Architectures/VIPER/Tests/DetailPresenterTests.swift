import BrewData
import BrewDomain
import Testing
@testable import VIPER

@MainActor
struct DetailPresenterTests {
    @Test func showsTheFavoriteStateAndToggles() async {
        let view = SpyDetailView()
        let presenter = DetailPresenter(
            coffee: Coffee.samples[1],
            interactor: DetailInteractor(dependencies: .test(favorites: InMemoryFavoritesRepository(["huila"])))
        )
        presenter.view = view

        await presenter.viewDidLoad()
        #expect(view.displayed.last?.favoriteButtonTitle == "Remove from favorites")

        await presenter.didTapFavorite()
        #expect(view.displayed.last?.favoriteButtonTitle == "Add to favorites")
    }
}
