public struct CatalogDisplayModel: Sendable, Equatable {
    public let rows: [CoffeeRowDisplayModel]
    public let offlineMessage: String?
}
