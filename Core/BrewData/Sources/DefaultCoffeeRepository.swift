import BrewDomain

struct DefaultCoffeeRepository: CoffeeRepository {
    private let api: any CoffeeAPI
    private let cache: any CoffeeCache

    init(api: any CoffeeAPI, cache: any CoffeeCache) {
        self.api = api
        self.cache = cache
    }

    func coffees() async throws -> [Coffee] {
        if let cached = await cache.load() {
            return cached.compactMap { $0.toDomain() }
        }
        return try await refresh()
    }

    func refresh() async throws -> [Coffee] {
        let fetched = try await api.fetchCoffees()
        await cache.save(fetched)
        return fetched.compactMap { $0.toDomain() }
    }

    func coffee(id: Coffee.ID) async throws -> Coffee {
        guard let coffee = try await coffees().first(where: { $0.id == id }) else {
            throw CoffeeError.notFound(id: id)
        }
        return coffee
    }
}
