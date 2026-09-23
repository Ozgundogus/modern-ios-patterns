public protocol CoffeeRepository: Sendable {
    /// Cached coffees when available, otherwise fetched.
    func coffees() async throws -> [Coffee]
    /// Always fetches. Throws when offline, but keeps the cached list for `coffees()`.
    func refresh() async throws -> [Coffee]
    func coffee(id: Coffee.ID) async throws -> Coffee
}
