import Foundation

/// Parses `modernios://product/<id>`. Shared by the SwiftUI and UIKit coordinators.
public enum DeepLink {
    public static func productID(from url: URL) -> Int? {
        guard url.scheme == "modernios", url.host() == "product" else { return nil }
        return Int(url.lastPathComponent)
    }
}
