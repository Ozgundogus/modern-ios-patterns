import Foundation

extension UserDefaults {
    static func isolated() -> UserDefaults {
        UserDefaults(suiteName: "SingletonTests-\(UUID().uuidString)")!
    }
}
