import Foundation

extension Coffee {
    /// Case- and diacritic-insensitive, so "cafe" finds "Café" and "ETHIOPIA" finds "Ethiopia".
    public func matches(_ query: String) -> Bool {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return ([name, origin] + tastingNotes).contains {
            $0.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
}
