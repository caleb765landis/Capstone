//
//  Utilities.swift
//  Collectathon
//
//  Created by Kaitlin Mahar from MongoDB
//  Found at https://github.com/mongodb/mongo-swift-driver/tree/main/Examples/FullStackSwiftExample
//  The project found in this repository was heavily influenced by Mikaela Caron's YouTube series:
//  https://www.youtube.com/playlist?list=PLMRqhzcHGw1Z7xNnqS_yUNm1k9dvq-HbM
//
//  Using this Utilities swift file made creating HTTP requests and encoding/decoding json much easier than me writing from scratch.
//

import Foundation

extension URLResponse {
    /// Whether this response's HTTP status code indicates success.
    var wasSuccessful: Bool {
        (200...299).contains(self.httpStatusCode)
    }

    /// The HTTP status code returned in this response.
    var httpStatusCode: Int {
        // Ok to force cast since we only use this for responses to HTTP requests.
        // swiftlint:disable:next force_cast
        (self as! HTTPURLResponse).statusCode
    }
}

/// Errors that can result from HTTP requests.
enum HTTPError: LocalizedError {
    case badResponse(code: Int)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case let .badResponse(code):
            return "Bad HTTP response with code \(code)"
        case let .decodingError(msg):
            return "Decoding error: \(msg)"
        }
    }
}

enum HTTP {
    /// Base URL where our application is running.
    static let baseURL = "http://10.0.0.134:8080"
    
    // Localhost base URL for local development
//    static let baseURL = URL(string: "http://127.0.0.1:8080")!

    /// Supported HTTP methods.
    enum Method: String {
        case POST, PATCH, GET, DELETE
    }

    /// Sends a GET request to the provided URL. Decodes the resulting extended JSON data into `dataType` and returns
    /// the result.
    static func get<T: Codable>(url: URL, dataType _: T.Type) async throws -> T {
        let data = try await sendRequest(to: url, body: nil as String?, method: .GET)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPError.decodingError("Error decoding type \(T.self) from HTTP response")
        }
    }

    /// Sends a POST request to the provided URL. If `body` is provided it will be encoded to extended JSON and sent
    /// as the body of the request.
    static func post<T: Codable>(url: URL, body: T?) async throws {
        try await self.sendRequest(to: url, body: body, method: .POST)
    }

    /// Sends a PATCH request to the provided URL. If `body` is provided it will be encoded to extended JSON and sent
    /// as the body of the request.
    static func patch<T: Codable>(url: URL, body: T?) async throws {
        try await self.sendRequest(to: url, body: body, method: .PATCH)
    }

    /// Sends a DELETE request to the provided URL.
    static func delete(url: URL) async throws {
        try await self.sendRequest(to: url, body: nil as String?, method: .DELETE)
    }

    /// Sends an HTTP request to the specified URL using the specified HTTP method. If `body` is provided it will be
    /// encoded to extended JSON and used as the body of the request. Returns the resulting data.
    /// Throws an error if the HTTP response code is not a successful one.
    @discardableResult
    private static func sendRequest<T: Codable>(
        to url: URL,
        body: T?,
        method: Method
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.wasSuccessful else {
            throw HTTPError.badResponse(code: response.httpStatusCode)
        }
        return data
    }
}
