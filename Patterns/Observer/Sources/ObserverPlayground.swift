#if canImport(SwiftUI)
import SwiftUI

struct ObserverPlayground: View {
    @State private var service = CartService()
    @State private var cart: CartModel?
    @State private var eventLog: [String] = []
    @State private var notificationCount = 0

    var body: some View {
        Form {
            if let cart {
                Section("@Observable → SwiftUI") {
                    CartBadge().environment(cart)
                }
                Section {
                    Button("Add espresso") { Task { await cart.add("Espresso") } }
                    Button("Clear cart") { Task { await cart.clear() } }
                }
            }
            Section("AsyncStream → event log") {
                ForEach(Array(eventLog.enumerated()), id: \.offset) { _, line in
                    Text(line).font(.caption.monospaced())
                }
            }
            Section("NotificationCenter → legacy code") {
                LabeledContent("Last count received", value: "\(notificationCount)")
            }
        }
        .task {
            let cart = CartModel(service: service)
            self.cart = cart
            await cart.observe()
        }
        .task {
            for await event in await service.events.subscribe() {
                eventLog.append(String(describing: event))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .cartDidChange)) { notification in
            notificationCount = CartNotification.count(from: notification) ?? 0
        }
    }
}

#Preview("Three ways to observe") {
    ObserverPlayground()
}
#endif
