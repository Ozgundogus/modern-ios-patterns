#if canImport(SwiftUI)
import SwiftUI

struct ProductDetailView: View {
    let product: Product
    let onBuy: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(product.name).font(.largeTitle)
            Text(product.formattedPrice).foregroundStyle(.secondary)
            Button("Buy", action: onBuy).buttonStyle(.borderedProminent)
        }
        .navigationTitle(product.name)
    }
}
#endif
