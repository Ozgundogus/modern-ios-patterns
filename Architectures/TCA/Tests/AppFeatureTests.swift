import BrewData
import BrewDomain
import ComposableArchitecture
import Testing
@testable import TCA

@MainActor
struct AppFeatureTests {
    @Test func tappingACoffeePushesItsDetail() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(\.catalog.coffeeTapped, Coffee.samples[0]) {
            $0.catalogPath[id: 0] = .detail(CoffeeDetailFeature.State(coffee: Coffee.samples[0]))
        }
    }

    @Test func togglingAFavoriteUpdatesTheOtherFeatures() async {
        var state = AppFeature.State()
        state.catalogPath.append(.detail(CoffeeDetailFeature.State(coffee: Coffee.samples[2])))
        let store = TestStore(initialState: state) {
            AppFeature()
        } withDependencies: {
            $0.brew = .from(.preview(favorites: []))
        }
        store.exhaustivity = .off

        await store.send(\.catalogPath[id: 0].detail.favoriteTapped)
        await store.finish()

        #expect(store.state.catalog.favoriteIDs == ["sumatra"])
        #expect(store.state.favorites.coffees == [Coffee.samples[2]])
    }
}
