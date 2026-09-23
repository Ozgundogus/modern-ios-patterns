#if canImport(UIKit)
import BrewData
import BrewDomain
import BrewUI
import UIKit

/// Classic MVC: the controller loads data from the model, keeps the screen state,
/// updates its views and creates the next screen. Simple to follow, and it grows fast.
public final class CatalogViewController: UITableViewController, UISearchResultsUpdating {
    private let dependencies: BrewDependencies
    private var coffees: [Coffee] = []
    private var favoriteIDs: Set<Coffee.ID> = []
    private var query = ""
    private var roast: Roast?
    private var searchTask: Task<Void, Never>?

    private lazy var dataSource = UITableViewDiffableDataSource<Int, Coffee.ID>(tableView: tableView) { [weak self] tableView, indexPath, id in
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee", for: indexPath)
        if let coffee = self?.coffees.first(where: { $0.id == id }) {
            cell.contentConfiguration = .coffee(coffee, isFavorite: self?.favoriteIDs.contains(id) ?? false)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
        super.init(style: .plain)
        title = "Catalog"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "coffee")
        tableView.dataSource = dataSource
        tableView.tableHeaderView = makeRoastControl()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Name, origin or tasting note"
        navigationItem.searchController = search

        refreshControl = UIRefreshControl()
        refreshControl?.addAction(UIAction { [weak self] _ in
            Task { await self?.refresh() }
        }, for: .valueChanged)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await reload() }
    }

    public func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
        searchTask?.cancel()
        searchTask = Task { await reload() }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = dataSource.itemIdentifier(for: indexPath),
              let coffee = coffees.first(where: { $0.id == id }) else { return }
        let detail = CoffeeDetailViewController(coffee: coffee, dependencies: dependencies)
        navigationController?.pushViewController(detail, animated: true)
    }

    func reload() async {
        do {
            coffees = try await dependencies.searchCoffees(query: query, roast: roast)
        } catch {
            navigationItem.prompt = error.localizedDescription
        }
        favoriteIDs = await dependencies.favoritesRepository.favoriteIDs()
        applySnapshot()
    }

    func refresh() async {
        defer { refreshControl?.endRefreshing() }
        do {
            _ = try await dependencies.coffeeRepository.refresh()
            navigationItem.prompt = nil
        } catch {
            navigationItem.prompt = error.localizedDescription
            return
        }
        await reload()
    }

    var visibleCoffeeIDs: [Coffee.ID] {
        dataSource.snapshot().itemIdentifiers
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Coffee.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(coffees.map(\.id))
        snapshot.reconfigureItems(coffees.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeRoastControl() -> UIView {
        let titles = ["All"] + Roast.allCases.map(\.displayName)
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 0
        control.addAction(UIAction { [weak self, weak control] _ in
            guard let self, let control else { return }
            roast = control.selectedSegmentIndex == 0 ? nil : Roast.allCases[control.selectedSegmentIndex - 1]
            Task { await self.reload() }
        }, for: .valueChanged)
        control.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        return control
    }
}

#Preview("Catalog") {
    UINavigationController(rootViewController: CatalogViewController(dependencies: .preview()))
}
#endif
