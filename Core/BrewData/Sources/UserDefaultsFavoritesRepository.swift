import BrewDomain
import Foundation

actor UserDefaultsFavoritesRepository: FavoritesRepository {
    private static let key = "brew.favoriteCoffeeIDs"
    private let defaults: UserDefaults

    /// Pass a suite name to keep favorites apart, e.g. in tests. `nil` uses `UserDefaults.standard`.
    init(suiteName: String? = nil) {
        defaults = suiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard
    }

    func favoriteIDs() -> Set<Coffee.ID> {
        Set(defaults.stringArray(forKey: Self.key) ?? [])
    }

    func setFavorite(_ isFavorite: Bool, for id: Coffee.ID) {
        var ids = favoriteIDs()
        if isFavorite {
            ids.insert(id)
        } else {
            ids.remove(id)
        }
        defaults.set(ids.sorted(), forKey: Self.key)
    }
}
