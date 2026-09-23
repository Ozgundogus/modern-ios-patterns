import Foundation

public struct SearchCoffeesUseCase: Sendable {
    private let repository: any CoffeeRepository

    public init(repository: any CoffeeRepository) {
        self.repository = repository
    }

    /// Filters by text and roast, sorted by name.
    public func callAsFunction(query: String = "", roast: Roast? = nil) async throws -> [Coffee] {
        try await repository.coffees()
            .filter { $0.matches(query) && (roast == nil || $0.roast == roast) }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
}
