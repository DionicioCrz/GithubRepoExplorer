//
//  AppDependencyContainer.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation
import UIKit

class AppDependencyContainer: RepositoryModuleFactoryProtocol {
    func getRootCoordinator(navController: UINavigationController) -> AppCoordinator {
        return AppCoordinator(navViewController: navController, factory: self)
    }
    func makeRepositoryViewController(coordinator: any RepoListCoordinatorDelegate) -> UIViewController {
        let network = makeNetworkManager()
        let repoService = makeRepositoryService(network: network)
        let commitService = makeCommitService(network: network)
        let repository = RepoRepository(repoService: repoService, commitService: commitService)
        let presenter = Presenter(repoRepository: repository, user: AppConfiguration.githubUsername)
        let viewController = RepositoryViewController(presenter: presenter)
        viewController.coordinatorDelegate = coordinator
        
        return viewController
    }
    
    func makeRepoDetailViewController(for repo: DisplayableRepositoryModel) -> UIViewController {
        // Whenever it needs to implement any presenter/service, can be done here.
        return RepoDetailViewController(repo: repo)
    }
}

// MARK: - Private Core Infrastructure Factories
private extension AppDependencyContainer {
    func makeNetworkManager() -> NetworkManager {
        return NetworkManagerImpl(session: .shared)
    }
    
    func makeRepositoryService(network: NetworkManager) -> RepositoryService {
        return RepositoryServiceImpl(networkManager: network)
    }
    
    func makeCommitService(network: NetworkManager) -> CommitService {
        return CommitServiceImpl(networkManager: network)
    }
}
