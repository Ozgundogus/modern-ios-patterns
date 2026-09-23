import Testing
import BrewDomain
@testable import BrewData

struct DefaultCoffeeRepositoryTests {
    let api = BundledCoffeeAPI()
    let cache = InMemoryCoffeeCache()
    var repository: DefaultCoffeeRepository { DefaultCoffeeRepository(api: api, cache: cache) }

    @Test func firstLoadFetchesAndCaches() async throws {
        let coffees = try await repository.coffees()

        #expect(coffees.count == 12)
        #expect(await cache.load()?.count == 12)
        #expect(await api.fetchCount == 1)
    }

    @Test func laterLoadsUseTheCache() async throws {
        _ = try await repository.coffees()
        _ = try await repository.coffees()

        #expect(await api.fetchCount == 1)
    }

    @Test func worksOfflineFromTheCache() async throws {
        _ = try await repository.coffees()
        await api.setReachable(false)

        #expect(try await repository.coffees().count == 12)
    }

    @Test func refreshThrowsOfflineButKeepsTheCache() async throws {
        _ = try await repository.coffees()
        await api.setReachable(false)

        await #expect(throws: CoffeeError.unavailable) {
            try await repository.refresh()
        }
        #expect(await cache.load()?.count == 12)
    }

    @Test func findsACoffeeByID() async throws {
        #expect(try await repository.coffee(id: "geisha").name == "Panamá Geisha")
    }

    @Test func unknownIDThrowsNotFound() async {
        await #expect(throws: CoffeeError.notFound(id: "decaf")) {
            try await repository.coffee(id: "decaf")
        }
    }
}
