//
//  RepositoryTableViewCell.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation
import UIKit

class ReposTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let nameLabel = UILabel.build(size: 17, weight: .bold)
    let descriptionLabel = UILabel.build(size: 14, numberOfLines: 0)
    let forksLabel = UILabel.build(size: 13)
    let starsLabel = UILabel.build(size: 13)
    let languageLabel = UILabel.build(size: 13)
    let commitsLabel = UILabel.build(size: 13, numberOfLines: 0)
    
    // Tracks the repo identity to prevent race conditions during cell reuse
    var currentRepoName: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: 12
        ).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
}

// MARK: - Setup
extension ReposTableViewCell {
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        statsStackView.addArrangedSubview(starsLabel)
        statsStackView.addArrangedSubview(forksLabel)
        statsStackView.addArrangedSubview(languageLabel)
        
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(statsStackView)
        mainStackView.addArrangedSubview(loadingIndicator)
        mainStackView.addArrangedSubview(commitsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Configuration
extension ReposTableViewCell {
    func configure(with repo: DisplayableRepositoryModel) {
        currentRepoName = repo.name
        nameLabel.text = repo.name
        descriptionLabel.attributedText = .paragraphStyle(text: repo.description, lineHeight: 2)
        starsLabel.text = " \(repo.stars)"
        forksLabel.text = "\(repo.forks)"
        languageLabel.text = repo.language
        
        commitsLabel.text = nil
        commitsLabel.isHidden = true
        commitsLabel.alpha = 1
        loadingIndicator.stopAnimating()
    }
    
    func showCommit(_ text: String) {
        loadingIndicator.stopAnimating()
        commitsLabel.isHidden = false
        commitsLabel.text = "Last commit: \(text)"
        commitsLabel.alpha = 1
    }
    
    func startLoading() {
        commitsLabel.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(with text: String) {
        loadingIndicator.stopAnimating()
        commitsLabel.isHidden = false
        commitsLabel.text = "Last commit: \(text)"
        commitsLabel.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.commitsLabel.alpha = 1
        }
    }
}
