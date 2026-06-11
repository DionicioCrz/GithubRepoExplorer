//
//  AppConfiguration.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import Foundation

// Single source of truth for environment-level values.
// Values are injected via xcconfig files — never hardcoded.
enum AppConfiguration {
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("URL hasn't been set in Info.plist — check Configuration.xcconfig")
        }
        return url
    }
    
    static var githubToken: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "GithubToken") as? String, !token.isEmpty else {
            return ""
        }
        return token
    }
    
    static let githubUsername = "githubUsername"
}
