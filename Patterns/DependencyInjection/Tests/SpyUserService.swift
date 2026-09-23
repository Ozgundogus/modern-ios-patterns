import Testing
@testable import DependencyInjection

actor SpyUserService: UserService {
    private(set) var requestedIDs: [Int] = []

    func fetchUser(id: Int) async throws -> User {
        requestedIDs.append(id)
        return .sample
    }
}
