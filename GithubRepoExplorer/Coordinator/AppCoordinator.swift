//
//  MainCoordinator.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navViewController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    private let factory: RepositoryModuleFactoryProtocol
    
    init(navViewController: UINavigationController, factory: RepositoryModuleFactoryProtocol) {
        self.navViewController = navViewController
        self.factory = factory
    }
    
    func start() {
        let viewController = factory.makeRepositoryViewController(coordinator: self)
        navViewController.pushViewController(viewController, animated: false)
    }
    
}

extension AppCoordinator: RepoListCoordinatorDelegate {
    func didSelectRepo(with repo: DisplayableRepositoryModel) {
        let detailVC = factory.makeRepoDetailViewController(for: repo)
        navViewController.pushViewController(detailVC, animated: true)
    }
}
