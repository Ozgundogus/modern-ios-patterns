#if canImport(SwiftUI)
import SwiftUI

struct CoffeeRowView: View {
    let data: CoffeeRowViewData

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(data.title).font(.headline)
                Text(data.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            if data.isFavorite {
                Image(systemName: "heart.fill").foregroundStyle(.pink)
            }
            Text(data.price).monospacedDigit()
        }
    }
}
#endif
