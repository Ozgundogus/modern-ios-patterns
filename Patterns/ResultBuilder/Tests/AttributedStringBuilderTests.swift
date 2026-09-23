import Foundation
import Testing
@testable import ResultBuilder

struct AttributedStringBuilderTests {
    @Test func joinsPlainStringsAndComponents() {
        let text = AttributedString {
            "Hello, "
            Strong("world")
            "!"
        }

        #expect(String(text.characters) == "Hello, world!")
        #expect(text.intent(of: "world") == .stronglyEmphasized)
        #expect(text.intent(of: "Hello") == nil)
    }

    @Test(arguments: [true, false])
    func supportsIf(showBadge: Bool) {
        let text = AttributedString {
            "Release"
            if showBadge {
                Code(" NEW")
            }
        }

        #expect(String(text.characters) == (showBadge ? "Release NEW" : "Release"))
    }

    @Test(arguments: [true, false])
    func supportsIfElse(isError: Bool) {
        let text = AttributedString {
            if isError {
                Strong("Failed")
            } else {
                Emphasis("Done")
            }
        }

        #expect(String(text.characters) == (isError ? "Failed" : "Done"))
    }

    @Test func supportsForLoops() {
        let text = AttributedString {
            for item in ["a", "b", "c"] {
                item
                LineBreak()
            }
        }

        #expect(String(text.characters) == "a\nb\nc\n")
    }

    @Test func nestedComponentsCombineTheirStyles() {
        let text = AttributedString {
            Strong {
                "Bold "
                Emphasis("and italic")
            }
        }

        #expect(text.intent(of: "Bold") == .stronglyEmphasized)
        #expect(text.intent(of: "and italic") == [.stronglyEmphasized, .emphasized])
    }

    @Test func hyperlinksCarryTheirDestination() {
        let url = URL(string: "https://example.com")!
        let text = AttributedString {
            "See "
            Hyperlink("the docs", destination: url)
        }

        #expect(text.link(of: "the docs") == url)
        #expect(text.link(of: "See") == nil)
    }
}
