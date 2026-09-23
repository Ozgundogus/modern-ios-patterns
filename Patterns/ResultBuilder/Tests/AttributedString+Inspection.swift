import Foundation

extension AttributedString {
    func intent(of text: String) -> InlinePresentationIntent? {
        guard let range = range(of: text) else { return nil }
        return self[range].runs.first?.inlinePresentationIntent
    }

    func link(of text: String) -> URL? {
        guard let range = range(of: text) else { return nil }
        return self[range].runs.first?.link
    }
}
