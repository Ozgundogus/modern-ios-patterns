#if canImport(SwiftUI)
import SwiftUI

/// `ProfileView` keeps its first view model in `@State`, so re-renders don't reset it.
public struct ProfileScreen: View {
    @Environment(\.dependencies) private var dependencies
    private let userID: Int

    public init(userID: Int) {
        self.userID = userID
    }

    public var body: some View {
        ProfileView(viewModel: dependencies.makeProfileViewModel(), userID: userID)
    }
}
#endif
