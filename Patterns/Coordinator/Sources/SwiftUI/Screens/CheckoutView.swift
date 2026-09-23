#if canImport(SwiftUI)
import SwiftUI

struct CheckoutView: View {
    let product: Product
    let onPlaceOrder: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Pay \(product.formattedPrice) for \(product.name)?")
            Button("Place order", action: onPlaceOrder).buttonStyle(.borderedProminent)
        }
        .navigationTitle("Checkout")
    }
}
#endif
