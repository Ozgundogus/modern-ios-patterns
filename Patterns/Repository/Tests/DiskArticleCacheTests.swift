import Foundation
import Testing
@testable import Repository

struct DiskArticleCacheTests {
    @Test func roundTripsThroughAFile() async {
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).json")
        defer { try? FileManager.default.removeItem(at: fileURL) }
        let entry = CachedArticles(articles: Article.samples, savedAt: Date(timeIntervalSince1970: 1_000))

        await DiskArticleCache(fileURL: fileURL).save(entry)

        #expect(await DiskArticleCache(fileURL: fileURL).load() == entry)
    }

    @Test func missingFileLoadsNothing() async {
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).json")

        #expect(await DiskArticleCache(fileURL: fileURL).load() == nil)
    }
}
