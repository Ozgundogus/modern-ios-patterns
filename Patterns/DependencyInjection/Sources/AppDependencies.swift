/// The Composition Root: the only place where concrete types are chosen and wired together.
public struct AppDependencies: Sendable {
    public let userService: any UserService

    public init(userService: any UserService) {
        self.userService = userService
    }

    public static let live = AppDependencies(userService: RemoteUserService())

    public static let preview = AppDependencies(
        userService: StubUserService(result: .success(.sample), delay: .milliseconds(300))
    )

    @MainActor
    public func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(userService: userService)
    }
}
