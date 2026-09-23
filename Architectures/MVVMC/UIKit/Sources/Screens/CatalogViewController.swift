#if canImport(UIKit)
import BrewDomain
import BrewUI
import MVVMCViewModels
import UIKit

/// Draws `CatalogViewModel` and forwards user input to it. It never pushes a screen: `select(_:)` goes to the coordinator.
public final class CatalogViewController: UITableViewController, UISearchResultsUpdating {
    private struct Row: Hashable {
        let coffee: Coffee
        let isFavorite: Bool
    }

    let viewModel: CatalogViewModel
    private var searchTask: Task<Void, Never>?

    private lazy var dataSource = UITableViewDiffableDataSource<Int, Row>(tableView: tableView) { tableView, indexPath, row in
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee", for: indexPath)
        cell.contentConfiguration = UIListContentConfiguration.coffee(row.coffee, isFavorite: row.isFavorite)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
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
            Task {
                await self?.viewModel.refresh()
                self?.refreshControl?.endRefreshing()
            }
        }, for: .valueChanged)

        startObserving { [weak self] in self?.render() }
        Task { await viewModel.load() }
    }

    public func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        guard query != viewModel.query else { return }
        viewModel.query = query
        reload()
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.select(row.coffee)
    }

    var visibleCoffeeIDs: [Coffee.ID] {
        dataSource.snapshot().itemIdentifiers.map(\.coffee.id)
    }

    var favoriteRowIDs: [Coffee.ID] {
        dataSource.snapshot().itemIdentifiers.filter(\.isFavorite).map(\.coffee.id)
    }

    private func render() {
        navigationItem.prompt = viewModel.offlineMessage
        var snapshot = NSDiffableDataSourceSnapshot<Int, Row>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.coffees.map { Row(coffee: $0, isFavorite: viewModel.isFavorite($0)) })
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func reload() {
        searchTask?.cancel()
        searchTask = Task { await viewModel.load() }
    }

    private func makeRoastControl() -> UIView {
        let titles = ["All"] + Roast.allCases.map(\.displayName)
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 0
        control.addAction(UIAction { [weak self, weak control] _ in
            guard let self, let control else { return }
            viewModel.roast = control.selectedSegmentIndex == 0 ? nil : Roast.allCases[control.selectedSegmentIndex - 1]
            reload()
        }, for: .valueChanged)
        control.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        return control
    }
}
#endif
