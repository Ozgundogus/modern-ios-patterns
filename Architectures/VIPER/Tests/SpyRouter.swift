import BrewDomain
@testable import VIPER

@MainActor
final class SpyRouter: DetailRouting {
    private(set) var shownDetails: [Coffee] = []

    func showDetail(for coffee: Coffee) {
        shownDetails.append(coffee)
    }
}
