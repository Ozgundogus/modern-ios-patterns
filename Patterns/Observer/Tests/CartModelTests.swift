import Observation
import os
import Testing
@testable import Observer

@MainActor
struct CartModelTests {
    @Test func followsTheServiceThroughItsEvents() async {
        let service = CartService(notificationCenter: .init())
        let cart = CartModel(service: service)
        let observation = Task { await cart.observe() }
        defer { observation.cancel() }
        #expect(await eventually { await service.events.subscriberCount == 1 })

        await service.add("Espresso")
        await service.add("Croissant")
        await service.remove("Espresso")

        #expect(await eventually { cart.items == ["Croissant"] })
    }

    @Test func swiftUIIsNotifiedWhenTheCountChanges() async {
        let service = CartService(notificationCenter: .init())
        let cart = CartModel(service: service)
        let observation = Task { await cart.observe() }
        defer { observation.cancel() }
        #expect(await eventually { await service.events.subscriberCount == 1 })

        let changed = OSAllocatedUnfairLock(initialState: false)
        withObservationTracking {
            _ = cart.count
        } onChange: {
            changed.withLock { $0 = true }
        }
        await cart.add("Espresso")

        #expect(await eventually { changed.withLock { $0 } })
    }
}
