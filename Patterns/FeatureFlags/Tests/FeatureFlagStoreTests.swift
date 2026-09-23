import Foundation
import Testing
@testable import FeatureFlags

@MainActor
struct FeatureFlagStoreTests {
    let defaults = UserDefaults(suiteName: "FeatureFlagTests-\(UUID().uuidString)")!

    func makeStore(_ remote: [String: FlagValue] = [:], userID: String = "user-1") -> FeatureFlagStore {
        FeatureFlagStore(source: StubFlagSource(remote), userID: userID, defaults: defaults)
    }

    @Test func usesTheDefaultWhenNothingElseIsSet() async {
        let store = makeStore()
        await store.refresh()

        #expect(store[AppFlags.newCheckout] == false)
        #expect(store[AppFlags.freeShippingThreshold] == 50)
        #expect(store[AppFlags.welcomeMessage] == "Welcome!")
    }

    @Test func remoteValueBeatsTheDefault() async {
        let store = makeStore([
            "new_checkout": .bool(true),
            "free_shipping_threshold": .int(35),
            "welcome_message": .string("Hi!"),
        ])

        await store.refresh()

        #expect(store[AppFlags.newCheckout] == true)
        #expect(store[AppFlags.freeShippingThreshold] == 35)
        #expect(store[AppFlags.welcomeMessage] == "Hi!")
    }

    @Test func localOverrideBeatsRemote() async {
        let store = makeStore(["new_checkout": .bool(true)])
        await store.refresh()

        store.setOverride(false, for: AppFlags.newCheckout)

        #expect(store[AppFlags.newCheckout] == false)
        #expect(store.isOverridden(AppFlags.newCheckout))
    }

    @Test func resettingOverridesFallsBackToRemote() async {
        let store = makeStore(["new_checkout": .bool(true)])
        await store.refresh()
        store.setOverride(false, for: AppFlags.newCheckout)

        store.resetOverrides()

        #expect(store[AppFlags.newCheckout] == true)
        #expect(!store.isOverridden(AppFlags.newCheckout))
    }

    @Test func overridesSurviveARelaunch() {
        makeStore().setOverride(true, for: AppFlags.applePay)

        let relaunched = makeStore()

        #expect(relaunched[AppFlags.applePay] == true)
    }

    @Test func wrongTypeFromRemoteFallsBackToTheDefault() async {
        let store = makeStore(["new_checkout": .string("yes")])
        await store.refresh()

        #expect(store[AppFlags.newCheckout] == false)
    }

    @Test func failedRefreshKeepsLastKnownValues() async {
        let source = StubFlagSource(["new_checkout": .bool(true)])
        let store = FeatureFlagStore(source: source, userID: "user-1", defaults: defaults)
        await store.refresh()

        await source.setError(URLError(.notConnectedToInternet))
        await store.refresh()

        #expect(store[AppFlags.newCheckout] == true)
    }
}
