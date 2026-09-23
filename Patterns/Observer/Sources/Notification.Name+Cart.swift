import Foundation

extension Notification.Name {
    /// Posted with the new item count in `userInfo[CartNotification.countKey]`.
    public static let cartDidChange = Notification.Name("CartDidChange")
}

public enum CartNotification {
    public static let countKey = "count"

    public static func count(from notification: Notification) -> Int? {
        notification.userInfo?[countKey] as? Int
    }
}
