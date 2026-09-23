import Foundation
import Testing
@testable import Facade

@MainActor
struct AccountServiceTests {
    let clock: TestClock
    let api: StubAuthAPI
    let tokenStore: InMemoryTokenStore
    let account: AccountService

    init() {
        let clock = TestClock()
        let api = StubAuthAPI(now: { clock.now })
        let tokenStore = InMemoryTokenStore()
        self.clock = clock
        self.api = api
        self.tokenStore = tokenStore
        account = AccountService(api: api, tokenStore: tokenStore, now: { clock.now })
    }

    @Test func signInStoresTokensAndLoadsTheProfile() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: StubAuthAPI.validPassword)

        #expect(account.state == .signedIn(.ada))
        #expect(await tokenStore.load()?.accessToken == "access-1")
    }

    @Test func wrongPasswordShowsAnErrorAndStoresNothing() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: "nope")

        #expect(account.state == .signedOut)
        #expect(account.errorMessage == "Wrong email or password.")
        #expect(await tokenStore.load() == nil)
    }

    @Test func restoreWithoutTokensStaysSignedOut() async {
        await account.restoreSession()

        #expect(account.state == .signedOut)
        #expect(await api.refreshCount == 0)
    }

    @Test func restoreWithValidTokensSkipsRefresh() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: StubAuthAPI.validPassword)
        let relaunched = AccountService(api: api, tokenStore: tokenStore, now: { [clock] in clock.now })

        await relaunched.restoreSession()

        #expect(relaunched.state == .signedIn(.ada))
        #expect(await api.refreshCount == 0)
    }

    @Test func restoreWithExpiredTokensRefreshesThem() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: StubAuthAPI.validPassword)
        clock.advance(by: 3_601)

        await account.restoreSession()

        #expect(account.state == .signedIn(.ada))
        #expect(await api.refreshCount == 1)
        #expect(await tokenStore.load()?.accessToken == "access-2")
    }

    @Test func failedRefreshSignsOutAndClearsTokens() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: StubAuthAPI.validPassword)
        clock.advance(by: 3_601)
        await api.setRefreshFails(true)

        await account.restoreSession()

        #expect(account.state == .signedOut)
        #expect(await tokenStore.load() == nil)
    }

    @Test func signOutRevokesAndClearsTokens() async {
        await account.signIn(email: StubAuthAPI.validEmail, password: StubAuthAPI.validPassword)

        await account.signOut()

        #expect(account.state == .signedOut)
        #expect(await api.revokedRefreshTokens == ["refresh-1"])
        #expect(await tokenStore.load() == nil)
    }
}
