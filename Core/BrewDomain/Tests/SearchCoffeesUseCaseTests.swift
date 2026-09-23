import Testing
@testable import BrewDomain

struct SearchCoffeesUseCaseTests {
    let search = SearchCoffeesUseCase(repository: StubCoffeeRepository())

    @Test func emptyQueryReturnsEverythingSortedByName() async throws {
        let names = try await search().map(\.name)

        #expect(names == ["Huila", "Sumatra Mandheling", "Yirgacheffe"])
    }

    @Test func filtersByText() async throws {
        let names = try await search(query: "chocolate").map(\.name)

        #expect(names == ["Sumatra Mandheling"])
    }

    @Test func filtersByRoast() async throws {
        let names = try await search(roast: .light).map(\.name)

        #expect(names == ["Yirgacheffe"])
    }

    @Test func combinesTextAndRoast() async throws {
        #expect(try await search(query: "ethiopia", roast: .dark).isEmpty)
    }

    @Test func passesRepositoryErrorsThrough() async {
        let search = SearchCoffeesUseCase(repository: StubCoffeeRepository(result: .failure(CoffeeError.unavailable)))

        await #expect(throws: CoffeeError.unavailable) {
            try await search()
        }
    }
}
