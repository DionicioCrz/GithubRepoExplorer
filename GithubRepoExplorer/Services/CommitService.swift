//
//  CommitService.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

protocol CommitService: AnyObject {
    func getCommits(user: String, repo: String) async throws -> String
}

final class CommitServiceImpl: CommitService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Fetch Last Commit
    func getCommits(user: String, repo: String) async throws -> String {
#if DEBUG
        try? await Task.sleep(nanoseconds: 2_000_000_000)
#endif
        // Request the las commit from the network layer and extacts the SHA, having a fallback if the array is empty.
        let commits: [CommitModel] = try await networkManager.request(endpoint: GHEndpoint.lastCommit(user: user, repo: repo))
        
        return commits.first?.sha ?? "No commits"
    }
    
}
