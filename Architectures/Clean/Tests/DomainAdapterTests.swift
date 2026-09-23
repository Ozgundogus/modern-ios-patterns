import BrewData
import BrewDomain
import Testing
@testable import Clean

struct DomainAdapterTests {
    @Test func connectsPortsToTheDomain() async throws {
        let adapter = DomainAdapter(dependencies: .preview(favorites: []))

        #expect(try await adapter.search(query: "", roast: .dark).map(\.id) == ["sumatra"])
        #expect(await adapter.toggleFavorite("huila"))
        #expect(try await adapter.favoriteCoffees().map(\.id) == ["huila"])
        #expect(try await adapter.coffee(id: "huila").name == "Huila")
    }
}
