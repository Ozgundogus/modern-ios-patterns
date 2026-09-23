public enum AppFlags {
    public static let newCheckout = Flag(
        "new_checkout",
        default: false,
        summary: "One-page checkout instead of the classic three steps"
    )

    public static let applePay = Flag(
        "apple_pay",
        default: false,
        summary: "Show the Apple Pay button"
    )

    public static let freeShippingThreshold = Flag(
        "free_shipping_threshold",
        default: 50,
        summary: "Order total (USD) for free shipping"
    )

    public static let welcomeMessage = Flag(
        "welcome_message",
        default: "Welcome!",
        summary: "Headline on the checkout screen"
    )

    public static let allBool = [newCheckout, applePay]
}
