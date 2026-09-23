import BrewDomain
import ComposableArchitecture

@Reducer
public struct CatalogFeature {
    @ObservableState
    public struct State: Equatable {
        public var coffees: [Coffee] = []
        public var favoriteIDs: Set<Coffee.ID> = []
        public var query = ""
        public var roast: Roast?
        public var isLoading = false
        public var offlineMessage: String?

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case task
        case refreshPulled
        case favoritesChanged
        case loaded([Coffee], favoriteIDs: Set<Coffee.ID>)
        case loadFailed(String)
        case refreshFailed(String)
        case favoriteIDsLoaded(Set<Coffee.ID>)
        case coffeeTapped(Coffee)
    }

    private enum CancelID {
        case search
    }

    @Dependency(\.brew) var brew

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.query), .binding(\.roast), .task:
                return load(&state)

            case .binding:
                return .none

            case .refreshPulled:
                return .run { [brew] send in
                    do {
                        try await brew.refreshCatalog()
                    } catch {
                        await send(.refreshFailed(error.localizedDescription))
                        return
                    }
                    await send(.task)
                }

            case .favoritesChanged:
                return .run { [brew] send in
                    await send(.favoriteIDsLoaded(brew.favoriteIDs()))
                }

            case let .loaded(coffees, favoriteIDs):
                state.isLoading = false
                state.coffees = coffees
                state.favoriteIDs = favoriteIDs
                return .none

            case let .loadFailed(message):
                state.isLoading = false
                state.offlineMessage = message
                return .none

            case let .refreshFailed(message):
                state.offlineMessage = message
                return .none

            case let .favoriteIDsLoaded(ids):
                state.favoriteIDs = ids
                return .none

            case .coffeeTapped:
                return .none
            }
        }
    }

    private func load(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { [brew, query = state.query, roast = state.roast] send in
            do {
                let coffees = try await brew.searchCoffees(query, roast)
                await send(.loaded(coffees, favoriteIDs: brew.favoriteIDs()))
            } catch {
                await send(.loadFailed(error.localizedDescription))
            }
        }
        .cancellable(id: CancelID.search, cancelInFlight: true)
    }
}
