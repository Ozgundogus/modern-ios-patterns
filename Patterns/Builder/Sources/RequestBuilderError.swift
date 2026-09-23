public enum RequestBuilderError: Error, Equatable {
    case invalidURL
    case bodyNotAllowed(HTTPMethod)
    case encodingFailed
}
