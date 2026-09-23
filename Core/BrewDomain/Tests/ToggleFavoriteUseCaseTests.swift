import Testing
@testable import BrewDomain

struct ToggleFavoriteUseCaseTests {
    @Test func togglesOnAndOff() async {
        let favorites = InMemoryFavoritesRepository()
        let toggle = ToggleFavoriteUseCase(favorites: favorites)

        #expect(await toggle("huila") == true)
        #expect(await favorites.favoriteIDs() == ["huila"])

        #expect(await toggle("huila") == false)
        #expect(await favorites.favoriteIDs().isEmpty)
    }
}
