#if canImport(UIKit)
import UIKit

final class FavoritesViewController: UITableViewController, FavoritesDisplaying {
    private let presenter: any FavoritesPresenting
    private(set) var rows: [CoffeeRowDisplayModel] = []

    init(presenter: any FavoritesPresenting) {
        self.presenter = presenter
        super.init(style: .plain)
        title = "Favorites"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "coffee")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await presenter.viewWillAppear() }
    }

    func display(_ rows: [CoffeeRowDisplayModel]) {
        self.rows = rows
        var empty = UIContentUnavailableConfiguration.empty()
        empty.text = "No favorites yet"
        empty.secondaryText = "Tap the heart on a coffee to save it here."
        contentUnavailableConfiguration = rows.isEmpty ? empty : nil
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee", for: indexPath)
        cell.contentConfiguration = .row(rows[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCoffee(id: rows[indexPath.row].id)
    }
}
#endif
