import Foundation
import Testing
@testable import BrewData

struct UserDefaultsFavoritesRepositoryTests {
    let suiteName = "BrewDataTests-\(UUID().uuidString)"

    @Test func startsEmpty() async {
        #expect(await UserDefaultsFavoritesRepository(suiteName: suiteName).favoriteIDs().isEmpty)
    }

    @Test func persistsAcrossInstances() async {
        await UserDefaultsFavoritesRepository(suiteName: suiteName).setFavorite(true, for: "huila")

        let relaunched = UserDefaultsFavoritesRepository(suiteName: suiteName)

        #expect(await relaunched.favoriteIDs() == ["huila"])
    }

    @Test func removesFavorites() async {
        let favorites = UserDefaultsFavoritesRepository(suiteName: suiteName)
        await favorites.setFavorite(true, for: "huila")

        await favorites.setFavorite(false, for: "huila")

        #expect(await favorites.favoriteIDs().isEmpty)
    }
}
