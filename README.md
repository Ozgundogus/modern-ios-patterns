# Modern iOS Patterns

> Real-world iOS architecture patterns in Swift 6: strict concurrency, actors, `@Observable` and `Sendable`. Each pattern shows **when to use it and when not to**.

> [!NOTE]
> 🚧 Work in progress. See the [Roadmap](docs/ROADMAP.md) for what is being built next.

## Why this repo?

Classic "GoF patterns in Swift" repos teach `Singleton` and `Visitor` with Swift 4 code.
This repo covers the patterns you actually ship in a production iOS app, written for Swift 6.
It also shows how the same feature looks in MVC, MVVM, TCA and Clean Architecture side by side.

## What makes it different

| | Classic pattern repos | **Modern iOS Patterns** |
|---|---|---|
| Swift version | Swift 4–5 | **Swift 6, strict concurrency on** |
| Patterns | GoF catalogue | **Coordinator, Repository, DI, Feature Flags, Offline-first sync…** |
| State | `ObservableObject`, delegates | **`@Observable`, actors, `Sendable`** |
| Guidance | How to use it | **How to use it + ⚠️ when NOT to use it** |
| Runnable | Snippets | **Clone → open → run: every pattern has a demo and tests** |

## Contents

### Part 1: Real-world patterns
| Pattern | Problem it solves | Status |
|---|---|---|
| Coordinator | Navigation logic leaking into views | 🔜 |
| Repository | Views and view models knowing about network and cache | 🔜 |
| Dependency Injection | Hard-to-test global singletons | 🔜 |
| Feature Flags | Shipping unfinished work safely | 🔜 |
| Offline-first Sync | Apps that break without network | 🔜 |

### Part 2: Same feature, four architectures
One screen built four times: **MVC · MVVM · TCA · Clean**, with a comparison table covering boilerplate, testability and learning curve.

## Branching

- `main`: stable, released content only.
- `development`: active work. All changes land here first and are merged to `main` for releases.

## License

MIT (to be added)
