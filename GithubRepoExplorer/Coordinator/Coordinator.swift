//
//  Coordinator.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navViewController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get }
    
    func start()
}
