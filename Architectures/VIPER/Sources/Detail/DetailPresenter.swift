import BrewDomain

/// The detail module has no router: nothing on this screen navigates.
@MainActor
public final class DetailPresenter: DetailPresenting {
    public weak var view: (any DetailDisplaying)?

    private let coffee: Coffee
    private let interactor: any DetailInteracting
    private var isFavorite = false

    public init(coffee: Coffee, interactor: any DetailInteracting) {
        self.coffee = coffee
        self.interactor = interactor
    }

    public func viewDidLoad() async {
        render()
        isFavorite = await interactor.isFavorite(coffee.id)
        render()
    }

    public func didTapFavorite() async {
        isFavorite = await interactor.toggleFavorite(coffee.id)
        render()
    }

    private func render() {
        view?.display(DetailDisplayModel(coffee: coffee, isFavorite: isFavorite))
    }
}
