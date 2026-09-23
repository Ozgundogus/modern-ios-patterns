import Foundation
import Testing
@testable import Builder

let baseURL = URL(string: "https://api.example.com/v1")!

struct RequestBuilderTests {
    @Test func buildsAGetRequestWithDefaults() throws {
        let request = try RequestBuilder(baseURL: baseURL).path("products").build()

        #expect(request.url?.absoluteString == "https://api.example.com/v1/products")
        #expect(request.httpMethod == "GET")
        #expect(request.timeoutInterval == 30)
        #expect(request.httpBody == nil)
    }

    @Test func addsQueryItemsAndSkipsNilValues() throws {
        let request = try RequestBuilder(baseURL: baseURL)
            .path("products")
            .query("search", "flat white")
            .query("category", nil)
            .query("page", "2")
            .build()

        #expect(request.url?.absoluteString == "https://api.example.com/v1/products?search=flat%20white&page=2")
    }

    @Test func setsHeadersAndBearerToken() throws {
        let request = try RequestBuilder(baseURL: baseURL)
            .header("Accept", "application/json")
            .bearerToken("abc")
            .build()

        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer abc")
    }

    @Test func encodesAJSONBody() throws {
        let request = try RequestBuilder(baseURL: baseURL)
            .method(.post)
            .jsonBody(["name": "Espresso"])
            .build()

        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.httpBody == Data(#"{"name":"Espresso"}"#.utf8))
    }

    @Test func rejectsABodyOnGet() throws {
        let builder = try RequestBuilder(baseURL: baseURL).jsonBody(["name": "Espresso"])

        #expect(throws: RequestBuilderError.bodyNotAllowed(.get)) {
            try builder.build()
        }
    }

    @Test func stepsDontAffectTheBaseBuilder() throws {
        let base = RequestBuilder(baseURL: baseURL).bearerToken("abc")

        let orders = try base.method(.post).path("orders").build()
        let products = try base.path("products").build()

        #expect(orders.httpMethod == "POST")
        #expect(products.httpMethod == "GET")
        #expect(products.url?.path() == "/v1/products")
        #expect(products.value(forHTTPHeaderField: "Authorization") == "Bearer abc")
    }
}

struct ShopAPITests {
    let api = ShopAPI(baseURL: baseURL, token: "abc")

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
