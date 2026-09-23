import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum RequestBuilderError: Error, Equatable {
    case invalidURL
    case bodyNotAllowed(HTTPMethod)
    case encodingFailed
}

/// Builds a `URLRequest` step by step.
///
/// It's a value type: every step returns a modified copy. A configured builder can be stored,
/// shared across tasks and reused as a base for other requests without one caller affecting another.
public struct RequestBuilder: Sendable {
    private let baseURL: URL
    private var method: HTTPMethod = .get
    private var path = ""
    private var queryItems: [URLQueryItem] = []
    private var headers: [String: String] = [:]
    private var body: Data?
    private var timeout: TimeInterval = 30

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func method(_ method: HTTPMethod) -> Self {
        with { $0.method = method }
    }

    public func path(_ path: String) -> Self {
        with { $0.path = path }
    }

    /// `nil` values are skipped, so optional filters don't need `if` statements at the call site.
    public func query(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        return with { $0.queryItems.append(URLQueryItem(name: name, value: value)) }
    }

    public func header(_ name: String, _ value: String) -> Self {
        with { $0.headers[name] = value }
    }

    public func bearerToken(_ token: String) -> Self {
        header("Authorization", "Bearer \(token)")
    }

    public func timeout(_ seconds: TimeInterval) -> Self {
        with { $0.timeout = seconds }
    }

    public func jsonBody(_ value: some Encodable, encoder: JSONEncoder = JSONEncoder()) throws(RequestBuilderError) -> Self {
        let data: Data
        do {
            data = try encoder.encode(value)
        } catch {
            throw .encodingFailed
        }
        return with {
            $0.body = data
            $0.headers["Content-Type"] = "application/json"
        }
    }

    public func build() throws(RequestBuilderError) -> URLRequest {
        if body != nil, method == .get {
            throw .bodyNotAllowed(method)
        }

        let url = path.isEmpty ? baseURL : baseURL.appending(path: path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw .invalidURL
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let finalURL = components.url else {
            throw .invalidURL
        }

        var request = URLRequest(url: finalURL, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        request.httpBody = body
        for (name, value) in headers {
            request.setValue(value, forHTTPHeaderField: name)
        }
        return request
    }

    private func with(_ change: (inout Self) -> Void) -> Self {
        var copy = self
        change(&copy)
        return copy
    }
}

extension URLRequest {
    /// The request as a `curl` command, handy for logs and bug reports.
    public var curlCommand: String {
        var parts = ["curl"]
        if let method = httpMethod, method != "GET" {
            parts.append("-X \(method)")
        }
        for (name, value) in (allHTTPHeaderFields ?? [:]).sorted(by: { $0.key < $1.key }) {
            parts.append("-H '\(name): \(value)'")
        }
        if let body = httpBody, let text = String(data: body, encoding: .utf8) {
            parts.append("-d '\(text)'")
        }
        parts.append("'\(url?.absoluteString ?? "")'")
        return parts.joined(separator: " ")
    }
}
