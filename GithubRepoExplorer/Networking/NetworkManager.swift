//
//  NetworkManager.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// MARK: - NetworkManager Protocol
protocol NetworkManager {
    func request<T: Decodable>(endpoint: any Endpoint) async throws -> T
}

class NetworkManagerImpl: NetworkManager {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(endpoint: any Endpoint) async throws -> T {
        guard let url = endpoint.url else { throw NetworkError.badURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        endpoint.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let token = AppConfiguration.githubToken
        
        if !token.isEmpty {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.connectivity
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        case 401, 403: throw NetworkError.unauthorized
        default: throw NetworkError.serverError
        }
    }
}
