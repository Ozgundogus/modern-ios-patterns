import Foundation
import Observation

/// Receives its dependency through the initializer (constructor injection).
/// It never reaches out to a global, so tests and previews can pass any `UserService`.
@MainActor
@Observable
public final class ProfileViewModel {
    public enum State: Equatable {
        case idle
        case loading
        case loaded(User)
        case failed(String)
    }

    public private(set) var state: State = .idle

    private let userService: any UserService

    public init(userService: any UserService) {
        self.userService = userService
    }

    public func load(userID: Int) async {
        state = .loading
        do {
            state = .loaded(try await userService.fetchUser(id: userID))
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
