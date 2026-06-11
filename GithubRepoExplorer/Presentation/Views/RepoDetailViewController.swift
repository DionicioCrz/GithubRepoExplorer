//
//  RepoDetailViewController.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 6/9/26.
//

import UIKit
import SafariServices

// MARK: - RepoDetailViewController
// Shows full details of a selected repository.
// Opens the repo on GitHub in Safari when tapped.
final class RepoDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let repo: DisplayableRepositoryModel
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsCard = RepoDetailCard()
    private let commitCard = RepoDetailCard()
    
    private let openInGitHubButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Open on GitHub"
        config.image = UIImage(systemName: "safari")
        config.imagePadding = 8
        config.cornerStyle = .large
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(repo: DisplayableRepositoryModel) {
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = repo.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        configure()
    }
}

// MARK: - Setup
extension RepoDetailViewController {
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(descriptionLabel)
        contentStack.addArrangedSubview(statsCard)
        contentStack.addArrangedSubview(commitCard)
        contentStack.addArrangedSubview(openInGitHubButton)
        
        openInGitHubButton.addTarget(self, action: #selector(openInGitHub), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func configure() {
        descriptionLabel.text = repo.description
        
        statsCard.configure(items: [
            ("⭐ Stars", "\(repo.stars)"),
            ("🍴 Forks", "\(repo.forks)"),
            ("💻 Language", repo.language)
        ])
        
        commitCard.configure(items: [
            ("🔖 Last commit", repo.lastCommit ?? "Loading...")
        ])
    }
    
    @objc private func openInGitHub() {
        guard let url = GHEndpoint.repoWebURL(user: AppConfiguration.githubUsername, repo: repo.name) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

// MARK: - RepoDetailCard
// Reusable card view for displaying key-value pairs in the detail screen.
private final class RepoDetailCard: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(items: [(String, String)]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        items.forEach { title, value in
            let row = makeRow(title: title, value: value)
            stackView.addArrangedSubview(row)
        }
    }
    
    private func makeRow(title: String, value: String) -> UIView {
        let titleLabel = UILabel.build(size: 13, color: .secondaryLabel)
        titleLabel.text = title
        let valueLabel = UILabel.build(size: 15, weight: .medium, numberOfLines: 0)
        valueLabel.text = value
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
}
