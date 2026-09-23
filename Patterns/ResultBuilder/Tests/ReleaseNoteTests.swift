import Foundation
import Testing
@testable import ResultBuilder

struct ReleaseNoteTests {
    @Test func rendersTheFullNote() {
        let text = ReleaseNote.sample.attributedText

        #expect(String(text.characters) == """
        Version 2.0 NEW
        • Offline mode
        • Faster search
        Breaking: iOS 17 is now required
        Read more in the docs
        """)
        #expect(text.intent(of: "NEW") == .code)
        #expect(text.intent(of: "iOS 17 is now required") == [.stronglyEmphasized, .emphasized])
    }

    @Test func showsANoteWhenNothingBreaks() {
        let note = ReleaseNote(
            version: "2.1",
            isNew: false,
            features: [],
            breakingChange: nil,
            docsURL: ReleaseNote.sample.docsURL
        )

        #expect(String(note.attributedText.characters) == "Version 2.1\nNo breaking changes.\nRead more in the docs")
    }
}
