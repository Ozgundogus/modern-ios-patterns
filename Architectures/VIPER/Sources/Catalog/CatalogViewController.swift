#if canImport(UIKit)
import BrewDomain
import UIKit

/// Passive view: forwards every event to the presenter and draws whatever it's given.
final class CatalogViewController: UITableViewController, CatalogDisplaying, UISearchResultsUpdating {
    private let presenter: any CatalogPresenting
    private(set) var rows: [CoffeeRowDisplayModel] = []

    init(presenter: any CatalogPresenting) {
        self.presenter = presenter
        super.init(style: .plain)
        title = "Catalog"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "coffee")
        tableView.tableHeaderView = makeRoastControl()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Name, origin or tasting note"
        navigationItem.searchController = search

        refreshControl = UIRefreshControl()
        refreshControl?.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Task {
                await self.presenter.didPullToRefresh()
                self.refreshControl?.endRefreshing()
            }
        }, for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await presenter.viewWillAppear() }
    }

    func display(_ model: CatalogDisplayModel) {
        rows = model.rows
        navigationItem.prompt = model.offlineMessage
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        Task { await presenter.didChangeQuery(query) }
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

    private func makeRoastControl() -> UIView {
        let control = UISegmentedControl(items: ["All"] + Roast.allCases.map(\.displayName))
        control.selectedSegmentIndex = 0
        control.addAction(UIAction { [weak self, weak control] _ in
            guard let self, let control else { return }
            let roast = control.selectedSegmentIndex == 0 ? nil : Roast.allCases[control.selectedSegmentIndex - 1]
            Task { await self.presenter.didSelectRoast(roast) }
        }, for: .valueChanged)
        control.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        return control
    }
}
#endif
