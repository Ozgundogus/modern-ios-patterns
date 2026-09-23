#if canImport(SwiftUI)
import SwiftUI

struct CartBadge: View {
    @Environment(CartModel.self) private var cart

    var body: some View {
        Label("\(cart.count)", systemImage: "cart")
            .font(.title2)
            .contentTransition(.numericText())
            .animation(.default, value: cart.count)
    }
}
#endif
