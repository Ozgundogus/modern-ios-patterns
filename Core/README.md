# Brew: the shared core

**Brew** is a small coffee catalog app. Its domain and data layers live here, with no UI, so the same app can be built with different architectures and UI frameworks on top of exactly the same core. Only the presentation layer changes.

## The app

| Screen | What it does |
|---|---|
| **Catalog** | Lists all coffees. Search by name, origin or tasting note. Filter by roast. Pull to refresh. Shows a heart on favorites. |
| **Detail** | Origin, roast, tasting notes, price and description. A button to add or remove the coffee from favorites. |
| **Favorites** | The coffees you marked, in catalog order. |

### Rules every presentation layer must follow

1. The catalog loads from the cache when there is one, so it works **offline** after the first launch.
2. Pull to refresh always hits the network. If that fails, the current list **stays on screen** and an offline message is shown.
3. Search is **case- and diacritic-insensitive**: `cafe` finds `Café`, `tarrazu` finds `Tarrazú`.
4. Favorites **persist** across launches and update everywhere as soon as they change.

## Layers

```mermaid
flowchart TB
    subgraph Presentation["Presentation (per architecture)"]
        UI[Views, view models, presenters, reducers…]
    end
    subgraph Domain["BrewDomain"]
        E[Coffee · Roast · CoffeeError]
        UC[SearchCoffeesUseCase<br/>ToggleFavoriteUseCase<br/>LoadFavoriteCoffeesUseCase]
        P{{CoffeeRepository<br/>FavoritesRepository}}
    end
    subgraph Data["BrewData"]
        R[DefaultCoffeeRepository]
        API[BundledCoffeeAPI]
        C[DiskCoffeeCache]
        F[UserDefaultsFavoritesRepository]
        DTO[CoffeeDTO]
        Deps[BrewDependencies]
    end
    UI --> UC
    UI --> P
    UC --> P
    R -.->|implements| P
    F -.->|implements| P
    R --> API
    R --> C
    API --> DTO
    Deps --> R
    Deps --> F
```

**The dependency rule:** arrows only point inward. `BrewDomain` imports nothing but Foundation. `BrewData` depends on `BrewDomain`. Presentation depends on `BrewDomain` and gets its implementations from `BrewDependencies`.

### [`BrewDomain`](BrewDomain/Sources)

| Type | Role |
|---|---|
| `Coffee`, `Roast` | Entities. Plain `Sendable` values with no persistence or JSON concerns. |
| `CoffeeRepository`, `FavoritesRepository` | What the domain needs from the outside world, as protocols. |
| `SearchCoffeesUseCase`, `ToggleFavoriteUseCase`, `LoadFavoriteCoffeesUseCase` | Application rules, callable like functions: `try await searchCoffees(query: "kenya")`. |
| `CoffeeError` | Errors with user-facing messages. |

### [`BrewData`](BrewData/Sources)

| Type | Role |
|---|---|
| `CoffeeDTO` | The JSON shape (`snake_case`, prices as strings). Internal: it never leaves this module. |
| `BundledCoffeeAPI` | Serves [`coffees.json`](BrewData/Sources/Resources/coffees.json) with simulated latency and an offline switch. |
| `DefaultCoffeeRepository` | Cache first, network on refresh, cache kept when offline. |
| `DiskCoffeeCache`, `UserDefaultsFavoritesRepository` | Persistence, isolated in actors. |
| `InMemoryCoffeeRepository`, `InMemoryFavoritesRepository` | Ready-made fakes for previews and tests of any presentation layer. |
| `BrewDependencies` | The Composition Root: `.live()` for the app, `.preview()` for previews and tests. |

## Using it

```swift
import BrewData
import BrewDomain

let dependencies = BrewDependencies.live()

let coffees = try await dependencies.searchCoffees(query: "ethiopia", roast: .light)
await dependencies.toggleFavorite("yirgacheffe")
let favorites = try await dependencies.loadFavoriteCoffees()
```

## Tests

`swift test --filter BrewDomainTests` and `swift test --filter BrewDataTests`. The domain is tested with its own stubs, without `BrewData`; the data layer is tested against the real bundled catalog, a disk cache in a temporary file and an isolated `UserDefaults` suite.
