#if canImport(UIKit)
import BrewDomain
import BrewUI
import MVVMCViewModels
import UIKit

public final class FavoritesViewController: UITableViewController {
    let viewModel: FavoritesViewModel
    private var coffees: [Coffee] = []

    public init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
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
        startObserving { [weak self] in self?.render() }
        Task { await viewModel.load() }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffees.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffee", for: indexPath)
        cell.contentConfiguration = UIListContentConfiguration.coffee(coffees[indexPath.row], isFavorite: true)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.select(coffees[indexPath.row])
    }

    private func render() {
        coffees = viewModel.coffees
        var empty = UIContentUnavailableConfiguration.empty()
        empty.text = "No favorites yet"
        empty.secondaryText = "Tap the heart on a coffee to save it here."
        contentUnavailableConfiguration = coffees.isEmpty ? empty : nil
        tableView.reloadData()
    }
}
#endif
