import Foundation

extension AttributedString {
    public init(@AttributedStringBuilder _ content: () -> AttributedString) {
        self = content()
    }
}
