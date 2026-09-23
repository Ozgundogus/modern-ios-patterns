@testable import VIPER

@MainActor
final class SpyDetailView: DetailDisplaying {
    private(set) var displayed: [DetailDisplayModel] = []

    func display(_ model: DetailDisplayModel) {
        displayed.append(model)
    }
}
