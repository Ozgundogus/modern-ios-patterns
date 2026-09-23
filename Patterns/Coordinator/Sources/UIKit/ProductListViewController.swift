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
#endif
