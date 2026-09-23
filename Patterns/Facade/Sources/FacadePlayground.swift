#if canImport(SwiftUI)
import SwiftUI

struct FacadePlayground: View {
    @State private var account = AccountService(
        api: StubAuthAPI(latency: .milliseconds(400)),
        tokenStore: InMemoryTokenStore()
    )

    var body: some View {
        Group {
            switch account.state {
            case .signedOut:
                SignInView()
            case .loading:
                ProgressView()
            case .signedIn(let profile):
                ProfileView(profile: profile)
            }
        }
        .environment(account)
        .task { await account.restoreSession() }
    }
}

#Preview("Sign in, restore, sign out") {
    FacadePlayground()
}
#endif
