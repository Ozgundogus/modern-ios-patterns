import BrewDomain
import os
@testable import Clean

/// One stub for every port, so each test states exactly what the outside world returns.
final class StubPorts: CoffeeSearching, CoffeeLoading, FavoritesReading, FavoriteToggling, Sendable {
    private struct State {
        var coffees = Coffee.samples
        var favorites: Set<Coffee.ID> = []
        var refreshError: (any Error)?
        var searches: [String] = []
    }

    private let state: OSAllocatedUnfairLock<State>

    init(favorites: Set<Coffee.ID> = [], refreshError: (any Error)? = nil) {
        state = OSAllocatedUnfairLock(uncheckedState: State(favorites: favorites, refreshError: refreshError))
    }

    var searches: [String] { state.withLockUnchecked { $0.searches } }

    func search(query: String, roast: Roast?) async throws -> [Coffee] {
        state.withLockUnchecked { state in
            state.searches.append(query)
            return state.coffees.filter { $0.matches(query) && (roast == nil || $0.roast == roast) }
        }
    }

    func refreshCatalog() async throws {
        if let error = state.withLockUnchecked({ $0.refreshError }) {
            throw error
        }
    }

    func coffee(id: Coffee.ID) async throws -> Coffee {
        guard let coffee = state.withLockUnchecked({ $0.coffees.first { $0.id == id } }) else {
            throw CoffeeError.notFound(id: id)
        }
        return coffee
    }

    func favoriteIDs() async -> Set<Coffee.ID> {
        state.withLockUnchecked { $0.favorites }
    }

    func favoriteCoffees() async throws -> [Coffee] {
        state.withLockUnchecked { state in state.coffees.filter { state.favorites.contains($0.id) } }
    }

    func toggleFavorite(_ id: Coffee.ID) async -> Bool {
        state.withLockUnchecked { state in
            if state.favorites.remove(id) == nil {
                state.favorites.insert(id)
                return true
            }
            return false
        }
    }
}
