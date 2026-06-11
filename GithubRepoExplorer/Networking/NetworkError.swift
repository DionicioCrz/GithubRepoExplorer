//
//  NetworkError.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case serverError
    case connectivity
    case decodingError
    case unauthorized
}
