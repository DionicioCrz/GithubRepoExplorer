//
//  RepoRepositoryProtocol.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/11/26.
//

import Foundation

protocol RepoRepositoryProtocol {
    func getRepository(user: String) async throws -> [DisplayableRepositoryModel]
    func getCommit(user: String, repo: String) async throws -> String
    func clearCache()
}
