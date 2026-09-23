#if canImport(SwiftUI)
import SwiftUI

struct SignInView: View {
    @Environment(AccountService.self) private var account
    @State private var email = StubAuthAPI.validEmail
    @State private var password = ""

    var body: some View {
        Form {
            Section {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                SecureField("Password (try \"password\")", text: $password)
            }
            if let message = account.errorMessage {
                Text(message).foregroundStyle(.red)
            }
            Button("Sign in") {
                Task { await account.signIn(email: email, password: password) }
            }
            .disabled(account.state == .loading)
        }
    }
}
#endif
