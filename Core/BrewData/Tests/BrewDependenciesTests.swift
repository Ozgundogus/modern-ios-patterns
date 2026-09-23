import Testing
import BrewDomain
@testable import BrewData

struct BrewDependenciesTests {
    @Test func previewWiresTheUseCases() async throws {
        let dependencies = BrewDependencies.preview(favorites: ["huila"])

        #expect(try await dependencies.searchCoffees(query: "colombia").map(\.id) == ["huila"])
        #expect(try await dependencies.loadFavoriteCoffees().map(\.id) == ["huila"])

        await dependencies.toggleFavorite("huila")

        #expect(try await dependencies.loadFavoriteCoffees().isEmpty)
    }
}
