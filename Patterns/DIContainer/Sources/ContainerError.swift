public enum ContainerError: Error, Equatable, CustomStringConvertible {
    case notRegistered(String)

    public var description: String {
        switch self {
        case .notRegistered(let type):
            "No registration for \(type). Register it in the container or one of its parents."
        }
    }
}
