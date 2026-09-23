import Foundation
import Testing
@testable import BrewData

struct DiskCoffeeCacheTests {
    @Test func roundTripsThroughAFile() async {
        let fileURL = FileManager.default.temporaryDirectory.appending(path: "\(UUID().uuidString).json")
        defer { try? FileManager.default.removeItem(at: fileURL) }

        await DiskCoffeeCache(fileURL: fileURL).save([.huila])

        #expect(await DiskCoffeeCache(fileURL: fileURL).load() == [.huila])
    }
}
