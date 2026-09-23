import Foundation

/// Lets you write rich text the way SwiftUI lets you write views: with plain statements,
/// `if`, `if/else` and `for`, instead of manual `append` calls and range math.
@resultBuilder
public enum AttributedStringBuilder {
    public static func buildExpression(_ text: String) -> AttributedString {
        AttributedString(text)
    }

    public static func buildExpression(_ text: AttributedString) -> AttributedString {
        text
    }

    public static func buildExpression(_ component: some RichText) -> AttributedString {
        component.attributedString
    }

    public static func buildBlock(_ parts: AttributedString...) -> AttributedString {
        joined(parts)
    }

    public static func buildOptional(_ part: AttributedString?) -> AttributedString {
        part ?? AttributedString()
    }

    public static func buildEither(first part: AttributedString) -> AttributedString {
        part
    }

    public static func buildEither(second part: AttributedString) -> AttributedString {
        part
    }

    public static func buildArray(_ parts: [AttributedString]) -> AttributedString {
        joined(parts)
    }

    private static func joined(_ parts: [AttributedString]) -> AttributedString {
        var result = AttributedString()
        for part in parts {
            result.append(part)
        }
        return result
    }
}
