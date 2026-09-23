actor InMemoryCoffeeCache: CoffeeCache {
    private var coffees: [CoffeeDTO]?

    init(coffees: [CoffeeDTO]? = nil) {
        self.coffees = coffees
    }

    func load() -> [CoffeeDTO]? {
        coffees
    }

    func save(_ coffees: [CoffeeDTO]) {
        self.coffees = coffees
    }
}
