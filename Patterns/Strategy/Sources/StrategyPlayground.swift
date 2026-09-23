#if canImport(SwiftUI)
import SwiftUI

struct StrategyPlayground: View {
    @State private var promoCode = ""

    private let cart = Cart.sample

    private var strategy: DiscountStrategy {
        DiscountStrategy.forPromoCode(promoCode) ?? .noDiscount
    }

    var body: some View {
        let summary = CheckoutSummary(cart: cart, strategy: strategy)
        Form {
            Section("Cart") {
                ForEach(cart.items) { item in
                    LabeledContent("\(item.quantity) × \(item.name)") {
                        Text(item.total, format: .currency(code: "USD"))
                    }
                }
            }
            Section("Promo code") {
                TextField("WELCOME10, SAVE5, COFFEE3FOR2, BULK", text: $promoCode)
                    .autocorrectionDisabled()
            }
            Section("Summary") {
                LabeledContent("Subtotal") { Text(summary.subtotal, format: .currency(code: "USD")) }
                LabeledContent(summary.discountName) { Text(-summary.discount, format: .currency(code: "USD")) }
                LabeledContent("Total") { Text(summary.total, format: .currency(code: "USD")).bold() }
            }
        }
    }
}

#Preview("Promo codes") {
    StrategyPlayground()
}
#endif
