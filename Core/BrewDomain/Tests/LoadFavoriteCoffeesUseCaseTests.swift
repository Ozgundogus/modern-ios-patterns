import Testing
@testable import BrewDomain

struct LoadFavoriteCoffeesUseCaseTests {
    @Test func returnsFavoritesInCatalogOrder() async throws {
        let load = LoadFavoriteCoffeesUseCase(
            repository: StubCoffeeRepository(),
            favorites: InMemoryFavoritesRepository(["sumatra", "yirgacheffe"])
        )

        #expect(try await load().map(\.id) == ["yirgacheffe", "sumatra"])
    }

    @Test func ignoresCoffeesThatNoLongerExist() async throws {
        let load = LoadFavoriteCoffeesUseCase(
            repository: StubCoffeeRepository(),
            favorites: InMemoryFavoritesRepository(["huila", "discontinued"])
        )

        #expect(try await load().map(\.id) == ["huila"])
    }
}
