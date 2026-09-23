import Foundation

public struct Hyperlink: RichText {
    public let attributedString: AttributedString

    public init(_ text: String, destination: URL) {
        var string = AttributedString(text)
        string.link = destination
        attributedString = string
    }
}
