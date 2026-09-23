import Foundation

public struct LineBreak: RichText {
    public init() {}

    public var attributedString: AttributedString {
        AttributedString("\n")
    }
}
