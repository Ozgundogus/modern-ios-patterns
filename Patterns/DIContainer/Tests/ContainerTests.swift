import Testing
@testable import DIContainer

final class Token: Sendable {}

struct ContainerTests {
    @Test func transientCreatesANewInstanceEachTime() throws {
        let container = Container()
        container.register(Token.self) { _ in Token() }

        let first = try container.resolve(Token.self)
        let second = try container.resolve(Token.self)

        #expect(first !== second)
    }

    @Test func singletonReturnsTheSameInstance() throws {
        let container = Container()
        container.register(Token.self, scope: .singleton) { _ in Token() }

        let first = try container.resolve(Token.self)
        let second = try container.resolve(Token.self)

        #expect(first === second)
    }

    @Test func missingRegistrationThrows() {
        let container = Container()

        #expect(throws: ContainerError.notRegistered("Token")) {
            try container.resolve(Token.self)
        }
    }

    @Test func registeringAgainReplacesTheFactory() throws {
        let container = Container()
        let override = Token()
        container.register(Token.self, scope: .singleton) { _ in Token() }
        _ = try container.resolve(Token.self)

        container.register(Token.self, scope: .singleton) { _ in override }

        #expect(try container.resolve(Token.self) === override)
    }

    @Test func factoriesCanResolveTheirOwnDependencies() throws {
        let container = Container()
        container.register((any AppLogger).self, scope: .singleton) { _ in ConsoleLogger() }
        container.register((any HTTPClient).self) { container in
            try URLSessionHTTPClient(logger: container.resolve())
        }

        #expect(try container.resolve((any HTTPClient).self) is URLSessionHTTPClient)
    }

    @Test func childSeesParentRegistrationsAndSharesItsSingletons() throws {
        let parent = Container()
        parent.register(Token.self, scope: .singleton) { _ in Token() }

        let fromChild = try parent.makeChild().resolve(Token.self)
        let fromParent = try parent.resolve(Token.self)

        #expect(fromChild === fromParent)
    }

    @Test func eachChildKeepsItsOwnSingletons() throws {
        let parent = Container()
        let first = parent.makeChild()
        let second = parent.makeChild()
        first.register(Token.self, scope: .singleton) { _ in Token() }
        second.register(Token.self, scope: .singleton) { _ in Token() }

        #expect(try first.resolve(Token.self) === first.resolve(Token.self))
        #expect(try first.resolve(Token.self) !== second.resolve(Token.self))
        #expect(throws: ContainerError.self) { try parent.resolve(Token.self) }
    }

    @Test func concurrentResolvesShareOneSingleton() async throws {
        let container = Container()
        container.register(Token.self, scope: .singleton) { _ in Token() }

        let ids = try await withThrowingTaskGroup(of: ObjectIdentifier.self) { group in
            for _ in 0..<100 {
                group.addTask { try ObjectIdentifier(container.resolve(Token.self)) }
            }
            return try await group.reduce(into: Set<ObjectIdentifier>()) { $0.insert($1) }
        }

        #expect(ids.count == 1)
    }
}
