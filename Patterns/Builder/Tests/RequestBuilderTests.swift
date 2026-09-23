import Foundation
import Testing
@testable import Builder

struct RequestBuilderTests {
    @Test func buildsAGetRequestWithDefaults() throws {
        let request = try RequestBuilder(baseURL: .testAPI).path("products").build()

        #expect(request.url?.absoluteString == "https://api.example.com/v1/products")
        #expect(request.httpMethod == "GET")
        #expect(request.timeoutInterval == 30)
        #expect(request.httpBody == nil)
    }

    @Test func addsQueryItemsAndSkipsNilValues() throws {
        let request = try RequestBuilder(baseURL: .testAPI)
            .path("products")
            .query("search", "flat white")
            .query("category", nil)
            .query("page", "2")
            .build()

        #expect(request.url?.absoluteString == "https://api.example.com/v1/products?search=flat%20white&page=2")
    }

    @Test func setsHeadersAndBearerToken() throws {
        let request = try RequestBuilder(baseURL: .testAPI)
            .header("Accept", "application/json")
            .bearerToken("abc")
            .build()

        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer abc")
    }

    @Test func encodesAJSONBody() throws {
        let request = try RequestBuilder(baseURL: .testAPI)
            .method(.post)
            .jsonBody(["name": "Espresso"])
            .build()

        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.httpBody == Data(#"{"name":"Espresso"}"#.utf8))
    }

    @Test func rejectsABodyOnGet() throws {
        let builder = try RequestBuilder(baseURL: .testAPI).jsonBody(["name": "Espresso"])

        #expect(throws: RequestBuilderError.bodyNotAllowed(.get)) {
            try builder.build()
        }
    }

    @Test func stepsDontAffectTheBaseBuilder() throws {
        let base = RequestBuilder(baseURL: .testAPI).bearerToken("abc")

        let orders = try base.method(.post).path("orders").build()
        let products = try base.path("products").build()

        #expect(orders.httpMethod == "POST")
        #expect(products.httpMethod == "GET")
        #expect(products.url?.path() == "/v1/products")
        #expect(products.value(forHTTPHeaderField: "Authorization") == "Bearer abc")
    }
}
