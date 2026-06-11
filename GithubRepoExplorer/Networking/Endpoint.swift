//
//  Endpoint.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// MARK: - Endpoint Protocol
// Centralizes URL construction using URLComponents.
// Prevents manual string interpolation errors and keeps URLs type-safe.
protocol Endpoint {
    var scheme: String { get }      // "https"
    var host: String { get }        // "api.github.com" o "api.twitter.com"
    var path: String { get }        // "/users/userName/repos"
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }  // GET, POST, etc.
    var headers: [String: String] { get }  // Endpoint's specific headers
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Endpoint {
    var scheme: String { "https" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

// Github-specific endpoint factory
struct GHEndpoint: Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    var host: String { AppConfiguration.baseURL }
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    
    static func repos(for user: String) -> GHEndpoint {
        GHEndpoint(path: "/users/\(user)/repos", queryItems: nil)
    }
    
    static func lastCommit(user: String, repo: String) -> GHEndpoint {
        GHEndpoint(
            path: "/repos/\(user)/\(repo)/commits",
            queryItems: [URLQueryItem(name: "per_page", value: "1")]
        )
    }
}

extension GHEndpoint {
    static func repoWebURL(user: String, repo: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/\(user)/\(repo)"
        return components.url
    }
}
