# Contributing

Thanks for helping out! Issues and pull requests are welcome.

## Requirements

- Xcode 16 or later (Swift 6)
- All code compiles in **Swift 6 language mode with strict concurrency and zero warnings**. CI treats warnings as errors.

## Branches

- `main`: stable, released content.
- `development`: active work. Open pull requests against `development`.

## Adding a pattern

Each pattern is self-contained in its own folder:

```
Patterns/<PatternName>/
├── README.md       Explanation, diagram, "When NOT to use"
├── Sources/        The pattern itself + SwiftUI previews, one type per file
└── Tests/          Swift Testing suites, one per file
```

1. Create the folder above.
2. Add the pattern name to the `patterns` list in `Package.swift`.
3. Add a row to the table in the root `README.md`.
4. Run `swift build` and `swift test` locally.

## Pattern README structure

Every pattern README follows the same sections so readers know where to look:

1. **The problem**: the real iOS situation that hurts without this pattern.
2. **The solution**: a short explanation with a Mermaid diagram.
3. **Code**: the key parts, with links to the source files.
4. **Run it**: which preview or test to open.
5. **⚠️ When NOT to use it**: an anti-pattern example and when the pattern is overkill.
6. **Trade-offs**: what it costs you.

## Naming

- **One primary type per file**, named after the type: `DiskArticleCache.swift`. Small private helpers and SwiftUI previews stay with the type that uses them.
- **Extensions** go in `Type+Purpose.swift`: `Article+PostDTO.swift`, `URLRequest+Curl.swift`.
- **Protocols** are named for the role (`ArticleCache`); **implementations** say how they do it (`DiskArticleCache`, `RemoteArticleAPI`, `URLSessionHTTPClient`).
- **Test doubles:** `Stub…` returns canned values, `Spy…` records calls, `InMemory…` is a working fake.
- **Acronyms** keep one case: `userID`, `URLSession`, `HTTPClient`, `PostDTO`. Never `userId` or `HttpClient`.
- **Singular** type names: `ArticleAPI`, `ArticleCache`, `ArticleRepository`.
- **Folders** use the pattern name in UpperCamelCase (`Patterns/OfflineSync`). Subfolders only group by platform or role (`SwiftUI/`, `UIKit/`, `Screens/`, `Vendor/`).
- **Demo screens** are named after the pattern: `<PatternName>Playground` in `<PatternName>Playground.swift`.
- **Tests:** one suite per file, named `<TypeUnderTest>Tests`. Shared test data lives in `Fixtures.swift` as static members (`Article.fixture`, `Product.espresso`), not globals.

## Code style

- Prefer value types, `Sendable` and actors over locks and `@unchecked Sendable`.
- Use `@Observable` for view state, `async/await` for asynchronous work.
- Write tests with Swift Testing (`import Testing`).
- Keep examples small: a pattern should be readable in about 10 minutes.
- Comments: only `// MARK:` sections and `///` doc comments for behavior that isn't obvious from the code. Explanations belong in the pattern's README.
