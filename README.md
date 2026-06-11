# GithubRepoExplorer

An iOS app that fetches and displays public GitHub repositories, showing key stats and the last commit for each repo — loaded asynchronously as you scroll.

---

## Screenshots

<img width="300" alt="Main Screen" src="https://github.com/user-attachments/assets/deefeb15-de68-4e26-9758-7956edb9f4f8" />
<img width="300" alt="Detail Screen" src="https://github.com/user-attachments/assets/d713f42c-b6a5-490c-ac1d-2fa35a28b0cf" />


## Features

- Fetches public repositories from the GitHub API
- Displays name, description, stars, forks, and language for each repo
- Loads the last commit SHA **on demand** as cells become visible — not all at once
- Animated commit appearance with fade-in per cell
- Pull to refresh — clears cache and reloads all data
- Tap a repo to see full details and open it on GitHub
- Bearer token authentication via xcconfig (never hardcoded)
- Graceful error handling with retry

---

## Architecture

### MVP + Clean Architecture + Coordinator

```
GithubRepoExplorer/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Configuration/
│   ├── AppConfiguration.swift
│   ├── Configuration.xcconfig
│   └── Secrets.xcconfig.example
├── Coordinator/
│   ├── Coordinator.swift
│   ├── AppCoordinator.swift
│   └── RepositoryModuleFactoryProtocol.swift
├── DI/
│   └── AppDependencyContainer.swift
├── Models/
│   ├── CommitModel.swift
│   ├── RepositoryModel.swift
│   └── DisplayableRepositoryModel.swift
├── Networking/
│   ├── Endpoint.swift
│   ├── NetworkError.swift
│   ├── NetworkErrorMapper.swift
│   └── NetworkManager.swift
├── Services/
│   ├── RepositoryService.swift
│   └── CommitService.swift
├── Repository/
│   ├── RepoRepositoryProtocol.swift
│   └── RepoRepository.swift
├── Presentation/
│   ├── Delegates/
│   │   ├── RepoViewDelegate.swift
│   │   └── RepoListCoordinatorDelegate.swift
│   ├── Presenter.swift
│   └── Views/
│       ├── ReposTableViewCell.swift
│       ├── RepositoryViewController.swift
│       └── RepoDetailViewController.swift
└── Extensions/
    └── UILabel+Build.swift
```

### Layer Responsibilities

| Layer | Responsibility |
|---|---|
| **Coordinator** | Navigation logic — ViewControllers never push/present directly |
| **DI Container** | Wires all dependencies in one place |
| **Presenter** | Presentation logic — no UIKit imports |
| **Repository** | Translates DTOs → Domain models, manages NSCache |
| **Services** | One network call per service (SRP) |
| **NetworkManager** | HTTP transport — decoupled from endpoints |

---

## Key Technical Decisions

### Diffable Data Source

Replaces the classic `UITableViewDataSource` + `reloadData()` approach. Diffable computes what changed between snapshots and animates only the affected rows — no full reload, no flickering during async commit loading.

`String` (repo name) is used as the item identifier instead of `DisplayableRepositoryModel` directly. This follows Apple's recommendation to use lightweight, stable identifiers — the full model lives in a separate array as the source of truth.

### On-Demand Commit Loading

Commits are fetched only when a cell becomes visible via `willDisplay`. A `Set<String>` tracks in-flight requests to prevent duplicate calls during fast scrolling. When a commit arrives, `reconfigureItems` updates only that cell.

### NSCache over Dictionary

`NSCache` auto-evicts under memory pressure and is thread-safe by default. The dictionary approach would grow unbounded and require manual cleanup.

### Coordinator Pattern

`AppCoordinator` owns all navigation. ViewControllers notify intent through `RepoListCoordinatorDelegate` — they never know what screen comes next.

### GitHub Token via xcconfig

The Bearer token is injected through `Secrets.xcconfig` (git-ignored) and read from `Info.plist` at runtime via `AppConfiguration`. Never hardcoded in source.

---

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/DionicioCrz/GitHubRepoExplorer.git
cd GitHubRepoExplorer
```

### 2. Add your GitHub token

```bash
cp Secrets.xcconfig.example Secrets.xcconfig
```

Open `Secrets.xcconfig` and replace the placeholder:

```
GITHUB_TOKEN = ghp_yourTokenHere
```

To generate a token: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)** → select `public_repo` scope.

### 3. Run

Open `GitHubRepoExplorer.xcodeproj` in Xcode and run on a simulator or device.

> The app works without a token but is limited to 60 API requests/hour. With a token the limit increases to 5,000/hour.

---

## Requirements

| | |
|---|---|
| iOS | 15.0+ |
| Xcode | 14.0+ |
| Swift | 5.10 |
| Dependencies | None |

---

## Tech Stack

- **Language:** Swift 5.10
- **UI:** UIKit — programmatic, no Storyboards
- **Concurrency:** async/await + `@MainActor`
- **Architecture:** MVP + Clean Architecture + Coordinator
- **Data:** `UITableViewDiffableDataSource`
- **Caching:** `NSCache`
- **Auth:** Bearer token via `.xcconfig`
- **Navigation:** Safari via `SFSafariViewController`

---

## Author

**Dionicio Cruz Velázquez** — iOS Engineer  
[github.com/DionicioCrz](https://github.com/DionicioCrz)
