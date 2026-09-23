import Foundation

extension DiscountStrategy {
    /// The only place that maps a promo code to a rule. Checkout code never switches on codes.
    public static func forPromoCode(_ code: String) -> DiscountStrategy? {
        switch code.trimmingCharacters(in: .whitespaces).uppercased() {
        case "WELCOME10":
            .percentage(10)
        case "SAVE5":
            .fixedAmount(5)
        case "COFFEE3FOR2":
            .buyXGetYFree(productID: "espresso", buy: 2, free: 1)
        case "BULK":
            .tiered([
                Tier(minimumSubtotal: 30, percent: 5),
                Tier(minimumSubtotal: 60, percent: 10),
            ])
        default:
            nil
        }
    }
}
