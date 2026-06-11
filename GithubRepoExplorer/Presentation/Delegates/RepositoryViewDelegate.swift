//
//  RepositoryViewDelegate.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

protocol RepoViewDelegate: AnyObject {
    func displayRepos(_ repos: [DisplayableRepositoryModel])
    func displayError(_ message: String)
    func displayCommit(_ commit: String, for repoName: String)
    func willRefresh()
}
