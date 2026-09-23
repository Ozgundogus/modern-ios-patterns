#if canImport(SwiftUI)
import SwiftUI

struct LoginView: View {
    let onLogIn: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Log in to continue to checkout.")
                Button("Log in", action: onLogIn).buttonStyle(.borderedProminent)
            }
            .navigationTitle("Log in")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
    }
}
#endif
