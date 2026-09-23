import BrewDomain
import ComposableArchitecture

@Reducer
public struct CoffeeDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public let coffee: Coffee
        public var isFavorite = false

        public init(coffee: Coffee) {
            self.coffee = coffee
        }
    }

    public enum Action {
        case task
        case favoriteLoaded(Bool)
        case favoriteTapped
        case favoriteToggled(Bool)
    }

    @Dependency(\.brew) var brew

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { [brew, id = state.coffee.id] send in
                    await send(.favoriteLoaded(brew.favoriteIDs().contains(id)))
                }

            case let .favoriteLoaded(isFavorite), let .favoriteToggled(isFavorite):
                state.isFavorite = isFavorite
                return .none

            case .favoriteTapped:
                return .run { [brew, id = state.coffee.id] send in
                    await send(.favoriteToggled(brew.toggleFavorite(id)))
                }
            }
        }
    }
}
