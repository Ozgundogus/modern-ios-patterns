# Feature Flags

> Ship code that is turned off, then turn it on remotely, for some users or all of them.

## The problem

Without flags, every change is all-or-nothing and tied to an App Store release:

```swift
// ❌ Stringly-typed, scattered, and no way to turn it off after release
if UserDefaults.standard.bool(forKey: "newChekout") {  // typo: always false
    showNewCheckout()
}
```

- **No kill switch:** if the new checkout breaks, you wait days for a hotfix review.
- **Long-lived branches:** unfinished features stay unmerged until they're done.
- **Typos and type confusion:** string keys fail silently; the wrong type crashes or reads as `false`.
- **No gradual rollout:** you can't give a feature to 5% of users first.

## The solution

Declare every flag once, with a **type** and a **default**. Resolve values with a fixed precedence, and let views observe the result.

```mermaid
flowchart LR
    View["CheckoutEntryView<br/>flags[Flags.newCheckout]"] --> Store[FeatureFlagStore<br/>@Observable]
    Store --> O{"Local override?"}
    O -->|yes| UseO([Use override])
    O -->|no| R{"Remote value<br/>of the right type?"}
    R -->|yes| UseR([Use remote])
    R -->|no| UseD([Use default in code])
    Remote[RemoteFlagSource] -.->|refresh| Store
    Debug[Debug menu] -.->|setOverride| Store
```

## Code

**1. Typed flags in one place.** See [`Flag.swift`](Sources/Flag.swift).

```swift
public enum Flags {
    public static let newCheckout = Flag("new_checkout", default: false, summary: "One-page checkout")
    public static let freeShippingThreshold = Flag("free_shipping_threshold", default: 50, summary: "…")
}
```

`Flags.newCheckout` is a `Flag<Bool>`, so `flags[Flags.newCheckout]` returns a `Bool`. No casts, no typos. When a flag is removed, the compiler lists every place that still uses it.

**2. A store with clear precedence.** See [`FeatureFlagStore.swift`](Sources/FeatureFlagStore.swift).

```swift
public subscript<Value>(_ flag: Flag<Value>) -> Value {
    for candidate in [overrides[flag.key], remoteValues[flag.key]] {
        if let candidate, let value = Value.decode(candidate, bucket: bucket) {
            return value
        }
    }
    return flag.defaultValue
}
```

A remote value of the wrong type is ignored, and a failed refresh keeps the last known values. Flags never take the app down.

**3. Percentage rollouts with stable buckets.** Remote config can send `{ "apple_pay": { "rollout": 25 } }`. Each user gets a bucket from a hash of the flag key and user ID. The same user always gets the same answer, and different flags split users differently.

```swift
// Swift's hashValue is seeded per process, so it would change on every launch. FNV-1a doesn't.
Rollout.bucket(for: "apple_pay:\(userID)") // 0..<100
```

**4. Views read flags from the environment.** See [`FeatureFlagViews.swift`](Sources/FeatureFlagViews.swift).

```swift
@Environment(FeatureFlagStore.self) private var flags

if flags[Flags.newCheckout] {
    Label("One-page checkout", systemImage: "bolt.fill")
}
```

**5. A debug menu.** `FeatureFlagDebugView` lists every `Bool` flag as a toggle. Overrides are stored in `UserDefaults`, so QA can set them once and they survive relaunches.

## Run it

- **Preview:** open [`FeatureFlagViews.swift`](Sources/FeatureFlagViews.swift). The playground shows the checkout screen above the debug menu. Flip a toggle and watch the screen change.
- **Tests:** `swift test --filter FeatureFlagsTests`. They cover precedence, persistence, type mismatches, offline refresh, rollout distribution across 1,000 users and JSON decoding. See [`FeatureFlagTests.swift`](Tests/FeatureFlagTests.swift).

## ⚠️ When NOT to use it

- **Configuration that never changes.** API base URLs or build-time settings belong in build configurations, not in a runtime flag system.
- **Flags that live forever.** Every flag doubles the paths through your code. Remove a flag once its feature is fully rolled out. A flag that's been `true` for everyone for months is dead code with extra steps.
- **Nested flags:**

  ```swift
  // ❌ Four combinations, most of them never tested
  if flags[Flags.newCheckout] {
      if flags[Flags.applePay] { … } else { … }
  } else {
      if flags[Flags.applePay] { … } else { … }
  }
  ```

  Keep flags independent, or combine them into one flag with a `String` value (`"classic"`, `"one_page"`, `"one_page_apple_pay"`).
- **Security.** Flags are client-side. Never hide paid features or admin tools behind a flag alone; the server must check too.

## Trade-offs

| 👍 Gains | 👎 Costs |
|---|---|
| Kill switch without an App Store release | More code paths to test |
| Merge unfinished work behind a flag | Flag cleanup is ongoing work |
| Gradual rollouts and A/B tests | Remote config is one more dependency |
| QA can test any combination from a debug menu | Harder to reason about what a user actually sees |
