#if canImport(SwiftUI)
import SwiftUI

struct ConfirmationView: View {
    let product: Product
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 64)).foregroundStyle(.green)
            Text("Your \(product.name) is on its way.")
            Button("Done", action: onDone).buttonStyle(.borderedProminent)
        }
        .navigationTitle("Order placed")
        .navigationBarBackButtonHidden()
    }
}
#endif
