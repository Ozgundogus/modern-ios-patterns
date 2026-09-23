#if canImport(UIKit)
import UIKit

final class DetailViewController: UIViewController, DetailDisplaying {
    private let presenter: any DetailPresenting
    private let summaryLabel = UILabel()
    private let factsLabel = UILabel()
    let favoriteButton = UIButton(configuration: .borderedProminent())

    init(presenter: any DetailPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        summaryLabel.numberOfLines = 0
        summaryLabel.font = .preferredFont(forTextStyle: .title3)
        factsLabel.numberOfLines = 0
        factsLabel.textColor = .secondaryLabel
        favoriteButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Task { await self.presenter.didTapFavorite() }
        }, for: .primaryActionTriggered)

        let stack = UIStackView(arrangedSubviews: [summaryLabel, factsLabel, favoriteButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])

        Task { await presenter.viewDidLoad() }
    }

    func display(_ model: DetailDisplayModel) {
        title = model.title
        summaryLabel.text = model.summary
        factsLabel.text = model.facts
        favoriteButton.configuration?.title = model.favoriteButtonTitle
    }
}
#endif
