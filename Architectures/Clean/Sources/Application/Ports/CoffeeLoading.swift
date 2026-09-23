import BrewDomain

public protocol CoffeeLoading: Sendable {
    func coffee(id: Coffee.ID) async throws -> Coffee
}
