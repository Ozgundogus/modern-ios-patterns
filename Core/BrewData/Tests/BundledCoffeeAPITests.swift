import Testing
import BrewDomain
@testable import BrewData

struct BundledCoffeeAPITests {
    @Test func loadsTheBundledCatalog() async throws {
        let coffees = try await BundledCoffeeAPI().fetchCoffees()

        #expect(coffees.count == 12)
        #expect(coffees.allSatisfy { $0.toDomain() != nil })
        #expect(Set(coffees.map(\.id)).count == coffees.count)
    }

    @Test func throwsWhenOffline() async {
        let api = BundledCoffeeAPI()
        await api.setReachable(false)

        await #expect(throws: CoffeeError.unavailable) {
            try await api.fetchCoffees()
        }
    }
}
