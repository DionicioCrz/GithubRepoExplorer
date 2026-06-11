//
//  RepositoryService.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

protocol RepositoryService: AnyObject {
    func getRepositories(user: String) async throws -> [RepositoryModel]
}

final class RepositoryServiceImpl: RepositoryService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getRepositories(user: String) async throws -> [RepositoryModel] {
        return try await networkManager.request(endpoint: GHEndpoint.repos(for: user))
    }
}
