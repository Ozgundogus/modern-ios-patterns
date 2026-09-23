#if canImport(UIKit)
import BrewDomain
import BrewUI
import UIKit

/// Shows a finished order. It has no logic of its own, so it gets a value and a closure instead of a view model.
public final class OrderConfirmationViewController: UIViewController {
    private let confirmation: OrderConfirmation
    private let onDone: () -> Void

    public init(confirmation: OrderConfirmation, onDone: @escaping () -> Void) {
        self.confirmation = confirmation
        self.onDone = onDone
        super.init(nibName: nil, bundle: nil)
        navigationItem.hidesBackButton = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let order = confirmation.order

        let heading = UILabel()
        heading.text = "Order \(confirmation.number) placed"
        heading.font = .preferredFont(forTextStyle: .title2)

        let details = UILabel()
        details.numberOfLines = 0
        details.textColor = .secondaryLabel
        details.text = "\(order.coffee.name), \(order.summary) · \(order.formattedTotal)"

        let done = UIButton(configuration: .borderedProminent(), primaryAction: UIAction(title: "Done") { [weak self] _ in
            self?.onDone()
        })

        addContentStack([heading, details, done])
    }
}
#endif
