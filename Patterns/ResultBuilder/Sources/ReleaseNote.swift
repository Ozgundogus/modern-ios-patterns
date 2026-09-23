import Foundation

public struct ReleaseNote: Sendable {
    public let version: String
    public let isNew: Bool
    public let features: [String]
    public let breakingChange: String?
    public let docsURL: URL

    public init(version: String, isNew: Bool, features: [String], breakingChange: String?, docsURL: URL) {
        self.version = version
        self.isNew = isNew
        self.features = features
        self.breakingChange = breakingChange
        self.docsURL = docsURL
    }

    public var attributedText: AttributedString {
        AttributedString {
            Strong("Version \(version)")
            if isNew {
                " "
                Code("NEW")
            }
            LineBreak()
            for feature in features {
                "• "
                feature
                LineBreak()
            }
            if let breakingChange {
                Strong {
                    "Breaking: "
                    Emphasis(breakingChange)
                }
            } else {
                Emphasis("No breaking changes.")
            }
            LineBreak()
            "Read more in "
            Hyperlink("the docs", destination: docsURL)
        }
    }
}

extension ReleaseNote {
    public static let sample = ReleaseNote(
        version: "2.0",
        isNew: true,
        features: ["Offline mode", "Faster search"],
        breakingChange: "iOS 17 is now required",
        docsURL: URL(string: "https://example.com/docs")!
    )
}
