import BrewDomain
import ComposableArchitecture
import Testing
@testable import TCA

@MainActor
struct CoffeeDetailFeatureTests {
    @Test func loadsAndTogglesTheFavorite() async {
        let store = TestStore(initialState: CoffeeDetailFeature.State(coffee: Coffee.samples[1])) {
            CoffeeDetailFeature()
        } withDependencies: {
            $0.brew.favoriteIDs = { ["huila"] }
            $0.brew.toggleFavorite = { _ in false }
        }

        await store.send(.task)
        await store.receive(\.favoriteLoaded) {
            $0.isFavorite = true
        }
        await store.send(.favoriteTapped)
        await store.receive(\.favoriteToggled) {
            $0.isFavorite = false
        }
    }
}
