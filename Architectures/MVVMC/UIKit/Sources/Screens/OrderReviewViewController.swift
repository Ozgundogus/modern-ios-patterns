#if canImport(UIKit)
import BrewUI
import MVVMCViewModels
import UIKit

public final class OrderReviewViewController: UIViewController {
    let viewModel: OrderReviewViewModel

    private let errorLabel = UILabel()
    private let placeButton = UIButton(configuration: .borderedProminent())

    public init(viewModel: OrderReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Review"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let order = viewModel.order

        let summary = UILabel()
        summary.numberOfLines = 0
        summary.text = """
        \(order.coffee.name)
        \(order.summary)
        Total: \(order.formattedTotal)
        """
        summary.font = .preferredFont(forTextStyle: .title3)

        errorLabel.numberOfLines = 0
        errorLabel.textColor = .systemRed

        placeButton.configuration?.title = "Place order"
        placeButton.addAction(UIAction { [weak self] _ in
            Task { await self?.viewModel.place() }
        }, for: .primaryActionTriggered)

        addContentStack([summary, errorLabel, placeButton])

        startObserving { [weak self] in self?.render() }
    }

    private func render() {
        errorLabel.text = viewModel.errorMessage
        errorLabel.isHidden = viewModel.errorMessage == nil
        placeButton.configuration?.showsActivityIndicator = viewModel.isPlacing
        placeButton.isEnabled = !viewModel.isPlacing
    }
}
#endif
