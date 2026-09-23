#if canImport(SwiftUI)
import SwiftUI

public struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    private let userID: Int

    public init(viewModel: ProfileViewModel, userID: Int) {
        _viewModel = State(initialValue: viewModel)
        self.userID = userID
    }

    public var body: some View {
        content
            .task { await viewModel.load(userID: userID) }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let user):
            VStack(spacing: 8) {
                Text(user.name).font(.title)
                Text(user.email).foregroundStyle(.secondary)
            }
        case .failed(let message):
            ContentUnavailableView(
                "Couldn't load profile",
                systemImage: "wifi.slash",
                description: Text(message)
            )
        }
    }
}

#Preview("Stub: success") {
    ProfileView(
        viewModel: ProfileViewModel(userService: StubUserService(result: .success(.sample))),
        userID: 1
    )
}

#Preview("Stub: failure") {
    ProfileView(
        viewModel: ProfileViewModel(
            userService: StubUserService(result: .failure(StubError("You're offline.")))
        ),
        userID: 1
    )
}

#Preview("Live network") {
    ProfileScreen(userID: 1)
        .environment(\.dependencies, .live)
}
#endif
