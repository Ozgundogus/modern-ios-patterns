protocol CoffeeAPI: Sendable {
    func fetchCoffees() async throws -> [CoffeeDTO]
}
