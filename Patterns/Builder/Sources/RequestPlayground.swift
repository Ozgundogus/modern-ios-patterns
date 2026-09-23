#if canImport(SwiftUI)
import SwiftUI

struct RequestPlayground: View {
    @State private var search = "latte"
    @State private var category = ""

    private let api = ShopAPI(baseURL: URL(string: "https://api.example.com/v1")!, token: "secret-token")

    var body: some View {
        Form {
            Section("GET /products") {
                TextField("search", text: $search)
                TextField("category (optional)", text: $category)
                curl { try api.products(search: search, category: category.isEmpty ? nil : category) }
            }
            Section("POST /orders") {
                curl { try api.placeOrder(NewOrder(productID: 42, quantity: 2)) }
            }
            Section("DELETE /orders/{id}") {
                curl { try api.cancelOrder(id: "A-1001") }
            }
        }
    }

    private func curl(_ makeRequest: () throws -> URLRequest) -> some View {
        let text: String
        do {
            text = try makeRequest().curlCommand
        } catch {
            text = "Error: \(error)"
        }
        return Text(text).font(.caption.monospaced()).textSelection(.enabled)
    }
}

#Preview("Requests as curl") {
    RequestPlayground()
}
#endif
