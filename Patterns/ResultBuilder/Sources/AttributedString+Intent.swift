import Foundation

extension AttributedString {
    /// Adds an intent to every run while keeping the ones already there, so `Strong { Emphasis("x") }` is bold and italic.
    func adding(_ intent: InlinePresentationIntent) -> AttributedString {
        var copy = self
        let runs = copy.runs.map { ($0.range, $0.inlinePresentationIntent ?? []) }
        for (range, existing) in runs {
            copy[range].inlinePresentationIntent = existing.union(intent)
        }
        return copy
    }
}
