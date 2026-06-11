//
//  CommitModel.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// MARK: - CommitModel (DTO - Network layer) 
struct CommitModel: Codable {
    let sha: String
}
