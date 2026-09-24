# Changelog

## Unreleased

- Minimum platforms raised to iOS 18 and macOS 15.
- SwiftUI tab bars use the `Tab` API instead of `.tabItem` and `.tag`.
- The Dependency Injection environment value is declared with `@Entry`.

## 1.0.0

First release.

### Patterns

- Real-world patterns: Dependency Injection, DI Container, Repository, Coordinator (SwiftUI and UIKit), Feature Flags, Offline-first Sync.
- Classic patterns, the iOS way: Adapter, Factory, Builder, Strategy, Decorator, Facade, Observer, State Machine, Result Builder, Singleton (and how to replace it).
- Every pattern has a README with a diagram and a "When NOT to use it" section, SwiftUI previews and Swift Testing tests.

### Brew, the sample app

- A shared core (`BrewDomain`, `BrewData`) with search, favorites, offline support and ordering.
- Seven architectures on that core: MVC, MVVM, MVVM-C, MVVM-R, Clean Architecture, VIPER and TCA, with a side-by-side comparison.
- MVVM-C in three UI stacks (SwiftUI, UIKit and a UIKit + SwiftUI hybrid) on the same view models, with a coordinator tree, a child flow and deep links.
- A step-by-step UIKit → SwiftUI migration guide.

### Tooling

- Swift 6 language mode with strict concurrency and zero warnings.
- CI on macOS and the iOS simulator for all three packages.
