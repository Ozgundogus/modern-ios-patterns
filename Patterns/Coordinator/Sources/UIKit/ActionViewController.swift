#if canImport(UIKit)
import UIKit

final class ActionViewController: UIViewController {
    var onAction: (() -> Void)?

    private let message: String
    private let buttonTitle: String

    init(title: String, message: String, buttonTitle: String) {
        self.message = message
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center

        let button = UIButton(
            configuration: .borderedProminent(),
            primaryAction: UIAction(title: buttonTitle) { [weak self] _ in
                self?.onAction?()
            }
        )

        let stack = UIStackView(arrangedSubviews: [label, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
}
#endif
