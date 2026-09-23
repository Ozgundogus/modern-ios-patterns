import Foundation
import os
import Testing
@testable import Observer

struct CartServiceTests {
    @Test func postsANotificationWithTheNewCount() async {
        let center = NotificationCenter()
        let counts = OSAllocatedUnfairLock<[Int]>(initialState: [])
        let token = center.addObserver(forName: .cartDidChange, object: nil, queue: nil) { notification in
            let count = CartNotification.count(from: notification)
            counts.withLock { $0.append(count ?? -1) }
        }
        defer { center.removeObserver(token) }
        let service = CartService(notificationCenter: center)

        await service.add("Espresso")
        await service.add("Croissant")
        await service.clear()

        #expect(counts.withLock { $0 } == [1, 2, 0])
    }

    @Test func publishesTypedEvents() async {
        let service = CartService(notificationCenter: NotificationCenter())
        let events = await service.events.subscribe()

        await service.add("Espresso")
        await service.clear()
        await service.events.finish()

        #expect(await Array(events) == [.itemAdded("Espresso"), .cleared])
    }
}
