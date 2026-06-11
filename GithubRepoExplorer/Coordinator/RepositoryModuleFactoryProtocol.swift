//
//  RepositoryModuleFactoryProtocol.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation
import UIKit

protocol RepositoryModuleFactoryProtocol: AnyObject {
    func makeRepositoryViewController(coordinator: RepoListCoordinatorDelegate) -> UIViewController
    func makeRepoDetailViewController(for repo: DisplayableRepositoryModel) -> UIViewController
}
