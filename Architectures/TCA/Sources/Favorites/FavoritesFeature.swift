import BrewDomain
import ComposableArchitecture

@Reducer
public struct FavoritesFeature {
    @ObservableState
    public struct State: Equatable {
        public var coffees: [Coffee] = []

        public init() {}
    }

    public enum Action {
        case task
        case loaded([Coffee])
        case coffeeTapped(Coffee)
    }

    @Dependency(\.brew) var brew

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    await send(.loaded((try? await brew.favoriteCoffees()) ?? []))
                }

            case let .loaded(coffees):
                state.coffees = coffees
                return .none

            case .coffeeTapped:
                return .none
            }
        }
    }
}
