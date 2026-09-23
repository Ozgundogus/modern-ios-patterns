import Foundation

/// The source of truth for the cart. Every change is published two ways:
/// typed events for Swift code in the app, and a notification for code that can't depend on this type.
public actor CartService {
    public let events = Broadcaster<CartEvent>()
    public private(set) var items: [String] = []

    private let notificationCenter: NotificationCenter

    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    public func add(_ item: String) async {
        items.append(item)
        await publish(.itemAdded(item))
    }

    public func remove(_ item: String) async {
        guard let index = items.firstIndex(of: item) else { return }
        items.remove(at: index)
        await publish(.itemRemoved(item))
    }

    public func clear() async {
        items.removeAll()
        await publish(.cleared)
    }

    private func publish(_ event: CartEvent) async {
        await events.send(event)
        notificationCenter.post(name: .cartDidChange, object: nil, userInfo: [CartNotification.countKey: items.count])
    }
}
