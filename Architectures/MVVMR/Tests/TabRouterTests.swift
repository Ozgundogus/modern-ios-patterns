import BrewDomain
import Testing
@testable import MVVMR

@MainActor
struct TabRouterTests {
    @Test func showDetailPushesARoute() {
        let router = TabRouter()

        router.showDetail(for: Coffee.samples[0])

        #expect(router.path == [.detail(Coffee.samples[0])])
    }

    @Test func favoritesTabPopsWhenTheFavoriteIsRemoved() {
        let router = TabRouter(popsWhenFavoriteIsRemoved: true)
        router.showDetail(for: Coffee.samples[0])

        router.didRemoveFavorite(Coffee.samples[0])

        #expect(router.path.isEmpty)
    }

    @Test func catalogTabStaysOnTheDetail() {
        let router = TabRouter()
        router.showDetail(for: Coffee.samples[0])

        router.didRemoveFavorite(Coffee.samples[0])

        #expect(router.path == [.detail(Coffee.samples[0])])
    }
}
