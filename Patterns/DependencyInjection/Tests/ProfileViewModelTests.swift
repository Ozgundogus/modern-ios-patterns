import Testing
@testable import DependencyInjection

actor SpyUserService: UserService {
    private(set) var requestedIDs: [Int] = []

    func fetchUser(id: Int) async throws -> User {
        requestedIDs.append(id)
        return .sample
    }
}

@MainActor
struct ProfileViewModelTests {
    @Test func startsIdle() {
        let viewModel = ProfileViewModel(userService: StubUserService(result: .success(.sample)))
        #expect(viewModel.state == .idle)
    }

    @Test func loadsUser() async {
        let viewModel = ProfileViewModel(userService: StubUserService(result: .success(.sample)))

        await viewModel.load(userID: 1)

        #expect(viewModel.state == .loaded(.sample))
    }

    @Test func showsErrorMessageOnFailure() async {
        let viewModel = ProfileViewModel(
            userService: StubUserService(result: .failure(StubError("You're offline.")))
        )

        await viewModel.load(userID: 1)

        #expect(viewModel.state == .failed("You're offline."))
    }

    @Test func requestsTheGivenUserID() async {
        let spy = SpyUserService()
        let viewModel = ProfileViewModel(userService: spy)

        await viewModel.load(userID: 42)

        #expect(await spy.requestedIDs == [42])
    }

    @Test func compositionRootInjectsItsService() async {
        let spy = SpyUserService()
        let dependencies = AppDependencies(userService: spy)

        await dependencies.makeProfileViewModel().load(userID: 7)

        #expect(await spy.requestedIDs == [7])
    }
}
