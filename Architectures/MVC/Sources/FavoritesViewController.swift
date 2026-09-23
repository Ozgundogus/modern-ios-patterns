#if canImport(UIKit)
import BrewData
import BrewDomain
import BrewUI
import UIKit

public final class FavoritesViewController: UITableViewController {
    private let dependencies: BrewDependencies
    private(set) var coffees: [Coffee] = []

    public init(dependencies: BrewDependencies) {
        self.dependencies = dependencies
        super.init(style: .plain)
        title = "Favorites"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "coffee")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await reload() }
    }

    func reload() async {
        coffees = (try? await dependencies.loadFavoriteCoffees()) ?? []
        var empty = UIContentUnavailableConfiguration.empty()
        empty.text = "No favorites yet"
        empty.secondaryText = "Tap the heart on a coffee to save it here."
        contentUnavailableConfiguration = coffees.isEmpty ? empty : nil
        tableView.reloadData()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffees.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee", for: indexPath)
        cell.contentConfiguration = .coffee(coffees[indexPath.row], isFavorite: true)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = CoffeeDetailViewController(coffee: coffees[indexPath.row], dependencies: dependencies)
        navigationController?.pushViewController(detail, animated: true)
    }
}
#endif
