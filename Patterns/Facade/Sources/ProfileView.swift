#if canImport(SwiftUI)
import SwiftUI

struct ProfileView: View {
    @Environment(AccountService.self) private var account
    let profile: UserProfile

    var body: some View {
        Form {
            LabeledContent("Name", value: profile.name)
            LabeledContent("Email", value: profile.email)
            Button("Sign out", role: .destructive) {
                Task { await account.signOut() }
            }
        }
    }
}
#endif
