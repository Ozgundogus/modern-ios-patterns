#if canImport(SwiftUI)
import SwiftUI

struct ProductListView: View {
    let products: [Product]
    let onSelect: (Product) -> Void

    var body: some View {
        List(products) { product in
            Button {
                onSelect(product)
            } label: {
                LabeledContent(product.name, value: product.formattedPrice)
            }
        }
        .navigationTitle("Shop")
    }
}
#endif
