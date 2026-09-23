import Foundation

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
