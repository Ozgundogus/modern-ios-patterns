#if canImport(UIKit)
import UIKit

final class ProductListViewController: UITableViewController {
    var onSelect: ((Product) -> Void)?

    private let products: [Product]

    init(products: [Product]) {
        self.products = products
        super.init(style: .insetGrouped)
        title = "Shop"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        var content = UIListContentConfiguration.valueCell()
        content.text = product.name
        content.secondaryText = product.formattedPrice
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect?(products[indexPath.row])
    }
}

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
