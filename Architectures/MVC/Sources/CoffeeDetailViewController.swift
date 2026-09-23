#if canImport(UIKit)
import BrewData
import BrewDomain
import BrewUI
import UIKit

public final class CoffeeDetailViewController: UIViewController {
    private let coffee: Coffee
    private let dependencies: BrewDependencies
    private(set) var isFavorite = false

    let favoriteButton = UIButton(configuration: .borderedProminent())

    public init(coffee: Coffee, dependencies: BrewDependencies) {
        self.coffee = coffee
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
        title = coffee.name
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

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
            Task { await self?.toggleFavorite() }
        }, for: .primaryActionTriggered)

        let stack = UIStackView(arrangedSubviews: [summary, facts, favoriteButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

        updateFavoriteButton()
        Task { await loadFavorite() }
    }

    func loadFavorite() async {
        isFavorite = await dependencies.favoritesRepository.favoriteIDs().contains(coffee.id)
        updateFavoriteButton()
    }

    func toggleFavorite() async {
        isFavorite = await dependencies.toggleFavorite(coffee.id)
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        favoriteButton.configuration?.title = isFavorite ? "Remove from favorites" : "Add to favorites"
        favoriteButton.configuration?.image = UIImage(systemName: isFavorite ? "heart.slash" : "heart")
    }
}

#Preview("Detail") {
    UINavigationController(rootViewController: CoffeeDetailViewController(coffee: Coffee.samples[1], dependencies: .preview()))
}
#endif
