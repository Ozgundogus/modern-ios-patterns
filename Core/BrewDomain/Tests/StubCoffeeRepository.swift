@testable import BrewDomain

struct StubCoffeeRepository: CoffeeRepository {
    var result: Result<[Coffee], any Error> = .success(Coffee.samples)

    func coffees() async throws -> [Coffee] {
        try result.get()
    }

    func refresh() async throws -> [Coffee] {
        try result.get()
    }

    func coffee(id: Coffee.ID) async throws -> Coffee {
        guard let coffee = try result.get().first(where: { $0.id == id }) else {
            throw CoffeeError.notFound(id: id)
        }
        return coffee
    }
}
