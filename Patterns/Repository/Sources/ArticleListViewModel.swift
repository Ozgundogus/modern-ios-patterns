import Foundation
import Observation

/// Talks to the repository only. It never sees a URL, a DTO or a cache.
@MainActor
@Observable
public final class ArticleListViewModel {
    public enum State: Equatable {
        case loading
        case loaded([Article])
        case failed(String)
    }

    public private(set) var state: State = .loading

    private let repository: any ArticleRepository

    public init(repository: any ArticleRepository) {
        self.repository = repository
    }

    public func load() async {
        do {
            state = .loaded(try await repository.articles())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    public func refresh() async {
        do {
            state = .loaded(try await repository.refresh())
        } catch {
            // Keep showing the current list if a pull-to-refresh fails.
            if case .loaded = state { return }
            state = .failed(error.localizedDescription)
        }
    }
}
