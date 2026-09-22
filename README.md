# Modern iOS Patterns

> Real-world iOS architecture patterns in Swift 6: strict concurrency, actors, `@Observable` and `Sendable`. Each pattern shows **when to use it and when not to**.

> [!NOTE]
> 🚧 Work in progress. See the [Roadmap](docs/ROADMAP.md) for what is being built next.

## Why this repo?

Classic "GoF patterns in Swift" repos teach `Singleton` and `Visitor` with Swift 4 code.
This repo covers the patterns you actually ship in a production iOS app, written for Swift 6.
It also builds the same app in five architectures and three UI stacks so you can compare them side by side.

## What makes it different

| | Classic pattern repos | **Modern iOS Patterns** |
|---|---|---|
| Swift version | Swift 4–5 | **Swift 6, strict concurrency on** |
| Patterns | Abstract GoF examples | **iOS use cases: wrapping an SDK, building a `URLRequest`, swapping a data source…** |
| State | `ObservableObject`, delegates | **`@Observable`, actors, `Sendable`, `AsyncStream`** |
| Guidance | How to use it | **How to use it + ⚠️ when NOT to use it** |
| Runnable | Snippets | **Clone → open → run: every pattern has a demo and tests** |

## Contents

### Part 1: Real-world patterns
| Pattern | Problem it solves | Status |
|---|---|---|
| Dependency Injection | Hard-to-test global singletons | 🔜 |
| DI Container | Wiring hundreds of dependencies by hand, thread-safely | 🔜 |
| Repository | Views and view models knowing about network and cache | 🔜 |
| Coordinator | Navigation logic leaking into views | 🔜 |
| Feature Flags | Shipping unfinished work safely | 🔜 |
| Offline-first Sync | Apps that break without network | 🔜 |

### Part 2: Classic patterns, the iOS way
Every pattern is shown through a real iOS use case, not a textbook example.

| Pattern | iOS use case | Status |
|---|---|---|
| Adapter | Wrapping a third-party analytics SDK behind your own protocol | 🔜 |
| Factory | Creating screens and their dependencies in one place | 🔜 |
| Builder | Building `URLRequest`s and complex configurations | 🔜 |
| Strategy | Swappable caching, sorting and pricing rules | 🔜 |
| Decorator | Adding logging and caching to a repository without changing it | 🔜 |
| Facade | One simple API over auth, keychain and session | 🔜 |
| Observer | `@Observable`, `AsyncStream` and `NotificationCenter` compared | 🔜 |
| State Machine | Screen and download states with enums | 🔜 |
| Result Builder | Writing your own SwiftUI-style DSL | 🔜 |
| Singleton ⚠️ | Why it hurts, and how to replace it | 🔜 |

### Part 3: Same app, five architectures
One app built five times: **MVC · MVVM · Clean Architecture · VIPER · TCA**.
Each version is compared on boilerplate, testability and learning curve.

### Part 4: Same app, three UI stacks
| Project | What it shows |
|---|---|
| Pure SwiftUI | `NavigationStack`, `@Observable`, `@Environment` DI |
| Pure UIKit | Programmatic UI, `UICollectionViewDiffableDataSource`, coordinators |
| Hybrid | UIKit app shell with SwiftUI screens: `UIHostingController`, `UIViewRepresentable`, gradual migration |

Parts 3 and 4 share one Domain and Data package, so only the presentation layer changes between versions.

## Branching

- `main`: stable, released content only.
- `development`: active work. All changes land here first and are merged to `main` for releases.

## License

MIT (to be added)
