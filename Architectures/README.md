# Same app, seven architectures

**Brew**, a small coffee catalog with search, favorites and offline support, built seven times on the same [core](../Core). Only the presentation layer changes, so the differences you see are the architecture and nothing else.

MVVM-C goes further. It's built in **SwiftUI, UIKit and a hybrid of both** on the same view models, with a coordinator tree and a child flow for ordering. The hybrid version comes with a [UIKit → SwiftUI migration guide](MVVMC/Hybrid).

| | UI | Where screen logic lives | Navigation | Source files | Lines* |
|---|---|---|---|---|---|
| [MVC](MVC) | UIKit | View controllers | Controllers push controllers | 4 | 246 |
| [MVVM](MVVM) | SwiftUI | `@Observable` view models | Views (`NavigationLink`) | 7 | 218 |
| [MVVM-C](MVVMC) | SwiftUI · UIKit · Hybrid | View models, shared by all three | A coordinator tree: one per tab, one per child flow | 20† | 611† |
| [MVVM-R](MVVMR) | SwiftUI | View models | One router per tab, one protocol per screen | 13 | 258 |
| [Clean](Clean) | SwiftUI | View models behind ports | Routes by ID + scene factory | 17 | 338 |
| [VIPER](VIPER) | UIKit | Presenters | Routers build modules | 28 | 485 |
| [TCA](TCA) | SwiftUI | Reducers | `StackState` in the app reducer | 9 | 366 |

<sub>* Non-empty lines in `Sources/`, without doc comments. All versions share [`BrewUI`](BrewUI/Sources) for rows and the detail layout, and the same [`Core`](../Core).<br/>† The SwiftUI version with its view models. It also builds the order flow, which the others don't, so it isn't a like-for-like count. UIKit: 20 files, 766 lines. The hybrid adds 5 files and 222 lines of coordinators and reuses the rest.</sub>

## How they compare

| | MVC | MVVM | MVVM-C | MVVM-R | Clean | VIPER | TCA |
|---|---|---|---|---|---|---|---|
| Boilerplate | Low | Low | Medium | Medium | High | Very high | Medium |
| Screen logic testable without UI | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Navigation testable without UI | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Cross-screen updates | On appear | On appear | Pushed by the parent coordinator | On appear | On appear | On appear | Explicit actions |
| Third-party dependency | — | — | — | — | — | — | TCA |
| Learning curve | Low | Low | Medium | Medium | High | High | High |
| Fits best | Small apps | Most SwiftUI apps | Flow-heavy apps | Many independent screens | Large, long-lived apps | Large UIKit teams | Complex shared state |

## Same feature, side by side

"User taps a coffee in the catalog":

| Architecture | What happens |
|---|---|
| MVC | `didSelectRowAt` creates `CoffeeDetailViewController` and pushes it |
| MVVM | `NavigationLink(value: coffee)`; the parent view model creates the detail view model |
| MVVM-C | `viewModel.select(coffee)` → `onSelect` → the tab's coordinator pushes the detail (SwiftUI: appends to its `path`) |
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
| MVVM-C (SwiftUI) | [`AppCoordinatorView`](MVVMC/SwiftUI/Sources/Coordinators/AppCoordinatorView.swift) | `WindowGroup { AppCoordinatorView() }` |
| MVVM-C (UIKit) | [`BrewTabBarController`](MVVMC/UIKit/Sources/BrewTabBarController.swift) | `window.rootViewController = BrewTabBarController()` |
| MVVM-C (Hybrid) | [`BrewTabBarController`](MVVMC/Hybrid/Sources/BrewTabBarController.swift) | `window.rootViewController = BrewTabBarController()` |
| MVVM-R | [`BrewAppView`](MVVMR/Sources/BrewAppView.swift) | `WindowGroup { BrewAppView() }` |
| Clean | [`BrewAppView`](Clean/Sources/Composition/BrewAppView.swift) | `WindowGroup { BrewAppView() }` |
| VIPER | [`BrewTabBarController`](VIPER/Sources/BrewTabBarController.swift) | `window.rootViewController = BrewTabBarController()` |
| TCA | [`AppView`](TCA/Sources/App/AppView.swift) | `WindowGroup { AppView() }` |

Tests: `swift test --package-path Architectures` runs everything that doesn't need UIKit, including the VIPER presenters and the MVVM-C view models and SwiftUI coordinators. The MVC view controllers and the UIKit and hybrid MVVM-C coordinators need UIKit, so their tests only run on an iOS simulator:

```bash
cd Architectures
xcodebuild test -scheme BrewArchitectures-Package -destination 'platform=iOS Simulator,name=iPhone 16' -skipMacroValidation
```

## Why a separate package?

TCA is a third-party dependency with its own dependencies. Keeping the architectures in their own package means the [patterns](../Patterns) and the [core](../Core) build with nothing but the Swift toolchain.
