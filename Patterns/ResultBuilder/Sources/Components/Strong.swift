import Foundation

public struct Strong: RichText {
    public let attributedString: AttributedString

    public init(_ text: String) {
        attributedString = AttributedString(text).adding(.stronglyEmphasized)
    }

    public init(@AttributedStringBuilder _ content: () -> AttributedString) {
        attributedString = content().adding(.stronglyEmphasized)
    }
}
