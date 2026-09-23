#if canImport(UIKit)
import BrewUI
import MVVMCViewModels
import UIKit

public final class CoffeeDetailViewController: UIViewController {
    let viewModel: CoffeeDetailViewModel

    let favoriteButton = UIButton(configuration: .tinted())
    private let orderButton = UIButton(configuration: .borderedProminent())

    public init(viewModel: CoffeeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.coffee.name
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let coffee = viewModel.coffee

        let summary = UILabel()
        summary.text = coffee.summary
        summary.numberOfLines = 0
        summary.font = .preferredFont(forTextStyle: .title3)

        let facts = UILabel()
        facts.numberOfLines = 0
        facts.textColor = .secondaryLabel
        facts.text = """
        Origin: \(coffee.origin)
        Roast: \(coffee.roast.displayName)
        Tasting notes: \(coffee.notesText)
        Price: \(coffee.formattedPrice)
        """

        favoriteButton.addAction(UIAction { [weak self] _ in
            Task { await self?.viewModel.toggleFavorite() }
        }, for: .primaryActionTriggered)

        orderButton.configuration?.title = "Order"
        orderButton.configuration?.image = UIImage(systemName: "bag")
        orderButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.order()
        }, for: .primaryActionTriggered)

        addContentStack([summary, facts, favoriteButton, orderButton])

        startObserving { [weak self] in self?.render() }
        Task { await viewModel.load() }
    }

    private func render() {
        let isFavorite = viewModel.isFavorite
        favoriteButton.configuration?.title = isFavorite ? "Remove from favorites" : "Add to favorites"
        favoriteButton.configuration?.image = UIImage(systemName: isFavorite ? "heart.slash" : "heart")
    }
}
#endif
