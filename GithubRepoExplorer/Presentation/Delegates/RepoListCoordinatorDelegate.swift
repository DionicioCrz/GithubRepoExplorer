//
//  RepoListCoordinatorDelegate.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation

protocol RepoListCoordinatorDelegate: AnyObject {
    func didSelectRepo(with repo: DisplayableRepositoryModel)
}
