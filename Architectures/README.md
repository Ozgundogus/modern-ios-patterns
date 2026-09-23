# Same app, seven architectures

**Brew**, a small coffee catalog with search, favorites and offline support, built seven times on the same [core](../Core). Only the presentation layer changes, so the differences you see are the architecture and nothing else.

| | UI | Where screen logic lives | Navigation | Source files | Lines* |
|---|---|---|---|---|---|
| [MVC](MVC) | UIKit | View controllers | Controllers push controllers | 4 | 246 |
| [MVVM](MVVM) | SwiftUI | `@Observable` view models | Views (`NavigationLink`) | 7 | 218 |
| [MVVM-C](MVVMC) | SwiftUI | View models | One coordinator owns all stacks | 8 | 264 |
| [MVVM-R](MVVMR) | SwiftUI | View models | One router per tab, one protocol per screen | 13 | 258 |
| [Clean](Clean) | SwiftUI | View models behind ports | Routes by ID + scene factory | 17 | 338 |
| [VIPER](VIPER) | UIKit | Presenters | Routers build modules | 28 | 485 |
| [TCA](TCA) | SwiftUI | Reducers | `StackState` in the app reducer | 9 | 366 |

<sub>* Non-empty lines in `Sources/`, without doc comments. All versions share [`BrewUI`](BrewUI/Sources) for rows and the detail layout, and the same [`Core`](../Core).</sub>

## How they compare

| | MVC | MVVM | MVVM-C | MVVM-R | Clean | VIPER | TCA |
|---|---|---|---|---|---|---|---|
| Boilerplate | Low | Low | Medium | Medium | High | Very high | Medium |
| Screen logic testable without UI | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Navigation testable without UI | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Cross-screen updates | On appear | On appear | Pushed by the coordinator | On appear | On appear | On appear | Explicit actions |
| Third-party dependency | — | — | — | — | — | — | TCA |
| Learning curve | Low | Low | Medium | Medium | High | High | High |
| Fits best | Small apps | Most SwiftUI apps | Flow-heavy apps | Many independent screens | Large, long-lived apps | Large UIKit teams | Complex shared state |

## Same feature, side by side

"User taps a coffee in the catalog":

| Architecture | What happens |
|---|---|
| MVC | `didSelectRowAt` creates `CoffeeDetailViewController` and pushes it |
| MVVM | `NavigationLink(value: coffee)`; the parent view model creates the detail view model |
| MVVM-C | `viewModel.select(coffee)` → `onSelect` → the coordinator appends a route |
| MVVM-R | `viewModel.select(coffee)` → `router.showDetail(for:)` appends a route |
| Clean | `NavigationLink(value: .detail(coffeeID:))`; the scene factory builds the detail from the ID |
| VIPER | View → `presenter.didSelectCoffee(id:)` → `router.showDetail(for:)` builds and pushes a module |
| TCA | `store.send(.coffeeTapped(coffee))` → `AppFeature` appends to `catalogPath` |

## Run it

Open [`Package.swift`](Package.swift) in Xcode (it pulls in `Core` and, for TCA, `swift-composable-architecture`). Each architecture's root file has a preview of the whole app:

| Architecture | Root | Use it in an app |
|---|---|---|
| MVC | [`BrewTabBarController`](MVC/Sources/BrewTabBarController.swift) | `window.rootViewController = BrewTabBarController()` |
| MVVM | [`BrewAppView`](MVVM/Sources/BrewAppView.swift) | `WindowGroup { BrewAppView() }` |
| MVVM-C | [`AppCoordinatorView`](MVVMC/Sources/Coordinator/AppCoordinatorView.swift) | `WindowGroup { AppCoordinatorView() }` |
| MVVM-R | [`BrewAppView`](MVVMR/Sources/BrewAppView.swift) | `WindowGroup { BrewAppView() }` |
| Clean | [`BrewAppView`](Clean/Sources/Composition/BrewAppView.swift) | `WindowGroup { BrewAppView() }` |
| VIPER | [`BrewTabBarController`](VIPER/Sources/BrewTabBarController.swift) | `window.rootViewController = BrewTabBarController()` |
| TCA | [`AppView`](TCA/Sources/App/AppView.swift) | `WindowGroup { AppView() }` |

Tests: `swift test --package-path Architectures` runs everything that doesn't need UIKit, including the VIPER presenters. MVC's logic lives in view controllers, so its tests only run on an iOS simulator:

```bash
cd Architectures
xcodebuild test -scheme BrewArchitectures-Package -destination 'platform=iOS Simulator,name=iPhone 16' -skipMacroValidation
```

## Why a separate package?

TCA is a third-party dependency with its own dependencies. Keeping the architectures in their own package means the [patterns](../Patterns) and the [core](../Core) build with nothing but the Swift toolchain.
