import BrewData
import BrewDomain
import ComposableArchitecture
import Testing
@testable import TCA

@MainActor
struct CatalogFeatureTests {
    @Test func loadsTheCatalogOnAppear() async {
        let store = TestStore(initialState: CatalogFeature.State()) {
            CatalogFeature()
        } withDependencies: {
            $0.brew = .from(.preview(favorites: ["huila"]))
        }

        await store.send(.task) {
            $0.isLoading = true
        }
        await store.receive(\.loaded) {
            $0.isLoading = false
            $0.coffees = [Coffee.samples[1], Coffee.samples[2], Coffee.samples[0]]
            $0.favoriteIDs = ["huila"]
        }
    }

    @Test func typingSearchesAgain() async {
        let store = TestStore(initialState: CatalogFeature.State()) {
            CatalogFeature()
        } withDependencies: {
            $0.brew = .from(.preview(favorites: []))
        }

        await store.send(\.binding.query, "ethiopia") {
            $0.query = "ethiopia"
            $0.isLoading = true
        }
        await store.receive(\.loaded) {
            $0.isLoading = false
            $0.coffees = [Coffee.samples[0]]
        }
    }

    @Test func failedRefreshKeepsTheListAndShowsAMessage() async {
        var state = CatalogFeature.State()
        state.coffees = Coffee.samples
        let store = TestStore(initialState: state) {
            CatalogFeature()
        } withDependencies: {
            $0.brew.refreshCatalog = { throw CoffeeError.unavailable }
        }

        await store.send(.refreshPulled)
        await store.receive(\.refreshFailed) {
            $0.offlineMessage = CoffeeError.unavailable.errorDescription
        }
    }

    @Test func tappingACoffeeChangesNothingLocally() async {
        let store = TestStore(initialState: CatalogFeature.State()) {
            CatalogFeature()
        }

        await store.send(.coffeeTapped(Coffee.samples[0]))
    }
}
