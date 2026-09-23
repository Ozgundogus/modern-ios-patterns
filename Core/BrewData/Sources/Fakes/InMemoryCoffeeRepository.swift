import BrewDomain

/// A ready-made repository for previews and tests of any presentation layer.
public actor InMemoryCoffeeRepository: CoffeeRepository {
    private var catalog: [Coffee]
    private var isReachable = true

    public init(coffees: [Coffee] = Coffee.samples) {
        catalog = coffees
    }

    public func setReachable(_ reachable: Bool) {
        isReachable = reachable
    }

    public func coffees() -> [Coffee] {
        catalog
    }

    public func refresh() throws -> [Coffee] {
        guard isReachable else { throw CoffeeError.unavailable }
        return catalog
    }

    public func coffee(id: Coffee.ID) throws -> Coffee {
        guard let coffee = catalog.first(where: { $0.id == id }) else {
            throw CoffeeError.notFound(id: id)
        }
        return coffee
    }
}
