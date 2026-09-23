import Foundation

public struct Code: RichText {
    public let attributedString: AttributedString

    public init(_ text: String) {
        attributedString = AttributedString(text).adding(.code)
    }

    public init(@AttributedStringBuilder _ content: () -> AttributedString) {
        attributedString = content().adding(.code)
    }
}
