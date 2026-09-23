import os

/// A small, thread-safe dependency container.
///
/// - Registrations are keyed by type, so `resolve` always returns the type you asked for.
/// - The container is `Sendable` without `@unchecked`: all mutable state sits behind a lock.
/// - Child containers see their parent's registrations but keep their own singletons.
public final class Container: Sendable {
    /// How long a resolved instance lives.
    public enum Scope: Sendable {
        /// A new instance on every `resolve`.
        case transient
        /// One instance per container. Use a child container to get one instance per feature.
        case singleton
    }

    private struct Registration: Sendable {
        let scope: Scope
        let factory: @Sendable (Container) throws -> any Sendable
    }

    private struct State: Sendable {
        var registrations: [ObjectIdentifier: Registration] = [:]
        var singletons: [ObjectIdentifier: any Sendable] = [:]
    }

    private let state = OSAllocatedUnfairLock(initialState: State())
    private let parent: Container?

    public init() {
        parent = nil
    }

    private init(parent: Container) {
        self.parent = parent
    }

    /// Creates a scope whose singletons live exactly as long as the child container.
    public func makeChild() -> Container {
        Container(parent: self)
    }

    /// Registers a factory. Registering the same type again replaces it, which is handy for test overrides.
    public func register<T: Sendable>(
        _ type: T.Type = T.self,
        scope: Scope = .transient,
        factory: @escaping @Sendable (Container) throws -> T
    ) {
        let key = ObjectIdentifier(type)
        let registration = Registration(scope: scope) { container in try factory(container) }
        state.withLock { state in
            state.registrations[key] = registration
            state.singletons[key] = nil
        }
    }

    /// Factories run outside the lock, so they can resolve their own dependencies.
    /// If two threads build the same singleton at once, the first stored instance wins.
    public func resolve<T: Sendable>(_ type: T.Type = T.self) throws -> T {
        let key = ObjectIdentifier(type)
        let (registration, cached) = state.withLock { state in
            (state.registrations[key], state.singletons[key])
        }

        guard let registration else {
            if let parent {
                return try parent.resolve(type)
            }
            throw ContainerError.notRegistered(String(describing: type))
        }

        if let cached = cached as? T {
            return cached
        }

        let instance = try registration.factory(self) as! T

        guard registration.scope == .singleton else {
            return instance
        }

        return state.withLock { state in
            if let existing = state.singletons[key] as? T {
                return existing
            }
            state.singletons[key] = instance
            return instance
        }
    }
}
