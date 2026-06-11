//
//  RepositoryModel.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// MARK: - RepositoryModel (DTO - Mapped to DisplayableRepositoryModel in RepoRepository)
struct RepositoryModel: Codable {
    let name: String?
    let description: String?
    let stargazersCount: Int?
    let forksCount: Int?
    let language: String?
}
