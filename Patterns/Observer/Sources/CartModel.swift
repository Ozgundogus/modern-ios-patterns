import Observation

/// UI state for SwiftUI. Views observe it with `@Observable`; it follows the service through its event stream.
@MainActor
@Observable
public final class CartModel {
    public private(set) var items: [String] = []

    public var count: Int {
        items.count
    }

    private let service: CartService

    public init(service: CartService) {
        self.service = service
    }

    public func add(_ item: String) async {
        await service.add(item)
    }

    public func clear() async {
        await service.clear()
    }

    /// Runs until the calling task is cancelled, e.g. from SwiftUI's `.task`.
    public func observe() async {
        for await event in await service.events.subscribe() {
            apply(event)
        }
    }

    private func apply(_ event: CartEvent) {
        switch event {
        case .itemAdded(let item):
            items.append(item)
        case .itemRemoved(let item):
            if let index = items.firstIndex(of: item) {
                items.remove(at: index)
            }
        case .cleared:
            items.removeAll()
        }
    }
}
