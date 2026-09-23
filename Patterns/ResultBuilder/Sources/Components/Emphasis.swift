import Foundation

public struct Emphasis: RichText {
    public let attributedString: AttributedString

    public init(_ text: String) {
        attributedString = AttributedString(text).adding(.emphasized)
    }

    public init(@AttributedStringBuilder _ content: () -> AttributedString) {
        attributedString = content().adding(.emphasized)
    }
}
