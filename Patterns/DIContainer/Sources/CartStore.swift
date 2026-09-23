public actor CartStore {
    public private(set) var items: [String] = []

    public init() {}

    public func add(_ item: String) {
        items.append(item)
    }
}
