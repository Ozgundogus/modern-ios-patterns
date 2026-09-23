import BrewDomain
import ComposableArchitecture

/// Composes the three features. Navigation is state: a stack per tab.
/// When a detail screen changes a favorite, this reducer tells the other features.
@Reducer
public struct AppFeature {
    @Reducer(state: .equatable)
    public enum Path {
        case detail(CoffeeDetailFeature)
    }

    public enum Tab: Hashable, Sendable {
        case catalog
        case favorites
    }

    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab = .catalog
        public var catalog = CatalogFeature.State()
        public var favorites = FavoritesFeature.State()
        public var catalogPath = StackState<Path.State>()
        public var favoritesPath = StackState<Path.State>()

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case catalog(CatalogFeature.Action)
        case favorites(FavoritesFeature.Action)
        case catalogPath(StackActionOf<Path>)
        case favoritesPath(StackActionOf<Path>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.catalog, action: \.catalog) {
            CatalogFeature()
        }
        Scope(state: \.favorites, action: \.favorites) {
            FavoritesFeature()
        }
        Reduce { state, action in
            switch action {
            case let .catalog(.coffeeTapped(coffee)):
                state.catalogPath.append(.detail(CoffeeDetailFeature.State(coffee: coffee)))
                return .none

            case let .favorites(.coffeeTapped(coffee)):
                state.favoritesPath.append(.detail(CoffeeDetailFeature.State(coffee: coffee)))
                return .none

            case .catalogPath(.element(id: _, action: .detail(.favoriteToggled))),
                 .favoritesPath(.element(id: _, action: .detail(.favoriteToggled))):
                return .merge(
                    .send(.catalog(.favoritesChanged)),
                    .send(.favorites(.task))
                )

            case .binding, .catalog, .favorites, .catalogPath, .favoritesPath:
                return .none
            }
        }
        .forEach(\.catalogPath, action: \.catalogPath)
        .forEach(\.favoritesPath, action: \.favoritesPath)
    }
}
