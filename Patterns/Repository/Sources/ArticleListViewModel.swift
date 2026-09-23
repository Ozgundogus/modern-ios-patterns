import Foundation
import Observation

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
            if case .loaded = state { return }
            state = .failed(error.localizedDescription)
        }
    }
}
