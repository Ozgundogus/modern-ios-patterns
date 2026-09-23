#if canImport(SwiftUI)
import SwiftUI

public struct OfflineBanner: View {
    private let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Label(message, systemImage: "wifi.slash")
            .font(.footnote)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.orange.opacity(0.2))
    }
}
#endif
