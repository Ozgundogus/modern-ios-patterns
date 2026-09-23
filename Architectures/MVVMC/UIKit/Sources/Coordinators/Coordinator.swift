#if canImport(UIKit)
/// A node in the coordinator tree. A parent keeps its children alive in `childCoordinators`
/// and must remove each one when its flow ends, or the whole flow leaks.
@MainActor
public protocol Coordinator: AnyObject {
    var childCoordinators: [any Coordinator] { get set }
    func start()
}

extension Coordinator {
    public func startChild(_ child: any Coordinator) {
        childCoordinators.append(child)
        child.start()
    }

    public func removeChild(_ child: any Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
#endif
