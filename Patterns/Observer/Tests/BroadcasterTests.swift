import Testing
@testable import Observer

@MainActor
struct BroadcasterTests {
    @Test func everySubscriberReceivesEveryElement() async {
        let broadcaster = Broadcaster<Int>()
        let first = await broadcaster.subscribe()
        let second = await broadcaster.subscribe()

        await broadcaster.send(1)
        await broadcaster.send(2)
        await broadcaster.finish()

        #expect(await Array(first) == [1, 2])
        #expect(await Array(second) == [1, 2])
    }

    @Test func lateSubscribersOnlyGetNewElements() async {
        let broadcaster = Broadcaster<Int>()
        await broadcaster.send(1)
        let late = await broadcaster.subscribe()

        await broadcaster.send(2)
        await broadcaster.finish()

        #expect(await Array(late) == [2])
    }

    @Test func cancelledSubscribersAreRemoved() async {
        let broadcaster = Broadcaster<Int>()
        let listener = Task {
            for await _ in await broadcaster.subscribe() {}
        }
        #expect(await eventually { await broadcaster.subscriberCount == 1 })

        listener.cancel()

        #expect(await eventually { await broadcaster.subscriberCount == 0 })
    }
}
