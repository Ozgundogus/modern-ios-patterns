protocol CoffeeCache: Sendable {
    func load() async -> [CoffeeDTO]?
    func save(_ coffees: [CoffeeDTO]) async
}
