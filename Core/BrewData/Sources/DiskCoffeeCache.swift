import Foundation

actor DiskCoffeeCache: CoffeeCache {
    private let fileURL: URL

    init(fileURL: URL = URL.cachesDirectory.appending(path: "brew-coffees.json")) {
        self.fileURL = fileURL
    }

    func load() -> [CoffeeDTO]? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode([CoffeeDTO].self, from: data)
    }

    func save(_ coffees: [CoffeeDTO]) {
        guard let data = try? JSONEncoder().encode(coffees) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
