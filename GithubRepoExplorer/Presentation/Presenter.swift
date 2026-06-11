//
//  Presenter.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    var delegate: RepoViewDelegate? { get set }
    func fetchRepository()
    func fetchLastCommit(for repoName: String)
    func refreshRepository()
}

class Presenter: PresenterProtocol {
    private let user: String
    private let repoRepository: RepoRepositoryProtocol
    weak var delegate: RepoViewDelegate?
    
    init(repoRepository: RepoRepositoryProtocol, user: String) {
        self.repoRepository = repoRepository
        self.user = user
    }
    
    func fetchRepository() {
        Task {
            do {
                let repos = try await repoRepository.getRepository(user: user)
                await MainActor.run { delegate?.displayRepos(repos) }
            } catch {
                await MainActor.run { delegate?.displayError(NetworkErrorMapper.message(for: error)) }
            }
        }
    }
    
    func fetchLastCommit(for repoName: String) {
        Task {
            do {
                let commit = try await repoRepository.getCommit(user: user, repo: repoName)
                await MainActor.run { delegate?.displayCommit(commit, for: repoName) }
            } catch {
                await MainActor.run { delegate?.displayCommit("Unavailable", for: repoName) }
            }
        }
    }
    
    func refreshRepository() {
        Task {
            await MainActor.run { delegate?.willRefresh() }
            repoRepository.clearCache()
            fetchRepository()
        }
    }
}
