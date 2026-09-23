# Modern iOS Patterns

[![CI](https://github.com/Ozgundogus/modern-ios-patterns/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Ozgundogus/modern-ios-patterns/actions/workflows/ci.yml)
![Swift 6](https://img.shields.io/badge/Swift-6-F05138?logo=swift&logoColor=white)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

> Real-world iOS architecture patterns in Swift 6: strict concurrency, actors, `@Observable` and `Sendable`. Each pattern shows **when to use it and when not to**.

## Why this repo?

Classic "GoF patterns in Swift" repos teach `Singleton` and `Visitor` with Swift 4 code.
This repo covers the patterns you actually ship in a production iOS app, written for Swift 6.

| | Classic pattern repos | **Modern iOS Patterns** |
|---|---|---|
| Swift version | Swift 4–5 | **Swift 6, strict concurrency on** |
| Examples | Abstract (`Shape`, `Animal`) | **Real iOS use cases** |
| State | `ObservableObject`, delegates | **`@Observable`, actors, `Sendable`** |
| Guidance | How to use it | **How to use it + ⚠️ when NOT to use it** |
| Runnable | Snippets | **SwiftUI previews and tests for every pattern** |

## Patterns

### Real-world patterns

| Pattern | Problem it solves |
|---|---|
| [Dependency Injection](Patterns/DependencyInjection) | Hard-to-test code that reaches for global singletons |
| [DI Container](Patterns/DIContainer) | Wiring and lifetimes that get out of hand as the app grows |
| [Repository](Patterns/Repository) | Network, cache and fallback rules scattered across view models |
| [Coordinator](Patterns/Coordinator) | Navigation decisions spread across screens (SwiftUI and UIKit) |
| [Feature Flags](Patterns/FeatureFlags) | Features that can't be turned off or rolled out gradually |
| [Offline-first Sync](Patterns/OfflineSync) | Apps that freeze or lose edits without a network |

### Classic patterns, the iOS way

| Pattern | iOS use case |
|---|---|
| [Adapter](Patterns/Adapter) | Wrapping third-party analytics SDKs behind your own interface |
| [Factory](Patterns/Factory) | Server-driven UI: turning JSON components into SwiftUI views |
| [Builder](Patterns/Builder) | Building `URLRequest`s without boilerplate or force unwraps |
| [Strategy](Patterns/Strategy) | Checkout discounts chosen by promo code |
| [Decorator](Patterns/Decorator) | Adding logging, caching and retries to a data loader |
| [Facade](Patterns/Facade) | One API over auth, Keychain token storage and refresh |
| [Observer](Patterns/Observer) | `@Observable` vs `AsyncStream` vs `NotificationCenter` |
| [State Machine](Patterns/StateMachine) | A download that can pause, fail and retry, with no impossible states |
| [Result Builder](Patterns/ResultBuilder) | A SwiftUI-style DSL for `AttributedString` |
| [Singleton ⚠️](Patterns/Singleton) | Why `static var shared` breaks in Swift 6, and what to do instead |

## Brew: a sample app core

[`Core/`](Core) contains the domain and data layers of **Brew**, a small coffee catalog app with search, favorites and offline support. It has no UI, so the same app can be built with different architectures on top of one shared core. See [Core/README.md](Core/README.md) for the screens, rules and layers.

## How it works

Every pattern is a self-contained folder with its own target in one Swift package:

```
Patterns/<PatternName>/
├── README.md       Problem, solution, diagram, ⚠️ when NOT to use it
├── Sources/        The pattern + SwiftUI previews
└── Tests/          Swift Testing tests
```

Each pattern README follows the same structure: **the problem → the solution → code → run it → when NOT to use it → trade-offs**.

## Getting started

Requirements: Xcode 16+ (Swift 6), iOS 17+ / macOS 14+.

```bash
git clone https://github.com/Ozgundogus/modern-ios-patterns.git
cd modern-ios-patterns
open Package.swift   # Opens in Xcode. Pick any pattern's view file to see its previews.
swift test           # Or run all tests from the terminal.
```

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
