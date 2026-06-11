//
//  DisplayableRepositoryModel.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// MARK: - DisplayableRepositoryModel (Domain Model)
// lastCommit is var because it's populated asynchronously after the initial load.
struct DisplayableRepositoryModel: Codable {
    let name: String
    let description: String
    let stars: Int
    let forks: Int
    let language: String
    var lastCommit: String?
}
