//
//  RepositoryViewController.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation
import UIKit

enum RepositorySection: Int {
    case main
}

class RepositoryViewController: UIViewController {
    
    // MARK: - Types
    typealias DataSource = UITableViewDiffableDataSource<RepositorySection, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<RepositorySection, String>
    
    // MARK: - Properties
    static let cellIdentifier = "ReposCell"
    
    let presenter: PresenterProtocol
    private var repositories: [DisplayableRepositoryModel] = []
    private var dataSource: DataSource!
    private var loadingRepos: Set<String> = []
    private var isRefreshing = false
    weak var coordinatorDelegate: RepoListCoordinatorDelegate?
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Repos"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        setupViews()
        setupTableView()
        setupDataSource()
        setupPresenter()
    }
    
    private func setupPresenter() {
        presenter.delegate = self
        presenter.fetchRepository()
    }
    
    @objc private func handleRefresh() {
        guard !isRefreshing else { return }
        isRefreshing = true
        presenter.refreshRepository()
    }
}

// MARK: - Layout
extension RepositoryViewController {
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(ReposTableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - Diffable Data Source
extension RepositoryViewController {
    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, repoName in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: RepositoryViewController.cellIdentifier,
                    for: indexPath
                  ) as? ReposTableViewCell,
                  let repo = self.repositories.first(where: { $0.name == repoName })
            else { return UITableViewCell() }
            
            cell.currentRepoName = repo.name
            cell.configure(with: repo)
            
            if let commit = repo.lastCommit {
                cell.showCommit(commit)
            } else {
                cell.startLoading()
            }
            return cell
        }
    }
    
    private func applySnapshot(with repos: [DisplayableRepositoryModel], animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(repos.map { $0.name })
        if animated {
            dataSource.apply(snapshot, animatingDifferences: true)
        } else {
            dataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
}

// MARK: - UITableViewDelegate
extension RepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let repoName = dataSource.itemIdentifier(for: indexPath),
              let repoModel = repositories.first(where: { $0.name == repoName }) else { return }
        coordinatorDelegate?.didSelectRepo(with: repoModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let repoName = dataSource.itemIdentifier(for: indexPath),
              let repo = repositories.first(where: { $0.name == repoName }),
              repo.lastCommit == nil,
              !loadingRepos.contains(repoName) else { return }
        loadingRepos.insert(repoName)
        presenter.fetchLastCommit(for: repoName)
    }
}

// MARK: - RepoViewDelegate
extension RepositoryViewController: RepoViewDelegate {
    func willRefresh() {
        loadingRepos.removeAll()
    }
    
    func displayRepos(_ repos: [DisplayableRepositoryModel]) {
        isRefreshing = false
        repositories = repos
        applySnapshot(with: repos, animated: false)
        tableView.refreshControl?.endRefreshing()
    }
    
    func displayCommit(_ commit: String, for repositoryName: String) {
        loadingRepos.remove(repositoryName)
        guard let index = repositories.firstIndex(where: { $0.name == repositoryName }) else { return }
        repositories[index].lastCommit = commit
        
        var snapshot = dataSource.snapshot()
        if snapshot.itemIdentifiers.contains(repositoryName) {
            snapshot.reconfigureItems([repositoryName])
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func displayError(_ error: String) {
        isRefreshing = false
        tableView.refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Something went wrong", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.presenter.fetchRepository()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
