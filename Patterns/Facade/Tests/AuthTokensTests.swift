import Foundation
import Testing
@testable import Facade

struct AuthTokensTests {
    let tokens = AuthTokens(accessToken: "a", refreshToken: "r", expiresAt: Date(timeIntervalSince1970: 100))

    @Test func validBeforeExpiry() {
        #expect(!tokens.isExpired(at: Date(timeIntervalSince1970: 99)))
    }

    @Test func expiredAtAndAfterExpiry() {
        #expect(tokens.isExpired(at: Date(timeIntervalSince1970: 100)))
        #expect(tokens.isExpired(at: Date(timeIntervalSince1970: 101)))
    }
}
