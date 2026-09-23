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

| Pattern | Problem it solves |
|---|---|
| [Dependency Injection](Patterns/DependencyInjection) | Hard-to-test code that reaches for global singletons |
| [DI Container](Patterns/DIContainer) | Wiring and lifetimes that get out of hand as the app grows |
| [Repository](Patterns/Repository) | Network, cache and fallback rules scattered across view models |
| [Coordinator](Patterns/Coordinator) | Navigation decisions spread across screens (SwiftUI and UIKit) |

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
