import Foundation
import Testing
@testable import Builder

struct ShopAPITests {
    let api = ShopAPI(baseURL: .testAPI, token: "abc")

    @Test func productsRequest() throws {
        let request = try api.products(search: "latte")

        #expect(request.curlCommand == """
        curl -H 'Accept: application/json' -H 'Authorization: Bearer abc' 'https://api.example.com/v1/products?search=latte'
        """)
    }

    @Test func placeOrderRequest() throws {
        let request = try api.placeOrder(NewOrder(productID: 42, quantity: 2))

        #expect(request.httpMethod == "POST")
        #expect(request.timeoutInterval == 60)
        let body = try JSONSerialization.jsonObject(with: request.httpBody ?? Data()) as? [String: Int]
        #expect(body == ["productID": 42, "quantity": 2])
    }

    @Test func cancelOrderRequest() throws {
        let request = try api.cancelOrder(id: "A-1")

        #expect(request.httpMethod == "DELETE")
        #expect(request.url?.absoluteString == "https://api.example.com/v1/orders/A-1")
    }
}
