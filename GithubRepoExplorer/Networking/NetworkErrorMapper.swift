//
//  NetworkErrorMapper.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation

enum NetworkErrorMapper {
    static func message(for error: NetworkError) -> String {
        switch error {
        case .connectivity:  return "No internet connection. Please check your network."
        case .serverError:   return "Server is not responding. Please try again later."
        case .unauthorized:  return "Access denied. Please check your credentials."
        case .decodingError: return "Error processing data. Please try again."
        case .badURL:        return "Internal error. Please try again."
        }
    }
    
    static func message(for error: Error) -> String {
        if let networkError = error as? NetworkError {
            return message(for: networkError)
        }
        return "An unexpected error ocurred. Please try again."
    }
}
