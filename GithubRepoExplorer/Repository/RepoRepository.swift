//
//  RepoRepository.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

class RepoRepository: RepoRepositoryProtocol {
    
    private let repoService: RepositoryService
    private let commitService: CommitService
    
    private var commitCache: NSCache<NSString, NSString> = {
        let cache = NSCache<NSString, NSString>()
        cache.countLimit = 100
        return cache
    }()
    
    init(repoService: RepositoryService, commitService: CommitService) {
        self.repoService = repoService
        self.commitService = commitService
    }
    
    func getRepository(user: String) async throws -> [DisplayableRepositoryModel] {
        let dtos = try await repoService.getRepositories(user: user)
        return dtos.compactMap { map($0) }
    }
    
    func getCommit(user: String, repo: String) async throws -> String {
        let key = repo as NSString
        
        if let cached = commitCache.object(forKey: key){
            return cached as String
        }
        
        let commit = try await commitService.getCommits(user: user, repo: repo)
        commitCache.setObject(commit as NSString, forKey: key)
        return commit
    }
    
    func clearCache() {
        commitCache.removeAllObjects()
    }
}

// MARK: - Private Mapper
// Translates RepositoryModel (DTO) → DisplayableRepositoryModel (Domain).
private extension RepoRepository {
    func map(_ dto: RepositoryModel) -> DisplayableRepositoryModel? {
        guard let name = dto.name,
              let stargazersCount = dto.stargazersCount,
              let forksCount = dto.forksCount else { return nil }
        
        return DisplayableRepositoryModel(
            name: name,
            description: dto.description ?? "No Description",
            stars: stargazersCount,
            forks: forksCount,
            language: dto.language ?? "N/A",
            lastCommit: nil
        )
    }
}
