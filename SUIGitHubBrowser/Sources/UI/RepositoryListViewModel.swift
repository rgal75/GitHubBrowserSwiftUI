//
//  RepositoryListViewModel.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2024. 12. 01..
//

import Foundation
import Combine

protocol RepositoryListViewModelProtocol {
    var repositories: [GitHubRepository] { get }
    var isLoadingRepositories: Bool { get }
    
    func fetchRepositories()
}

class RepositoryListViewModel: ObservableObject, RepositoryListViewModelProtocol {
    @Published var repositories: [GitHubRepository] = []
    @Published var isLoadingRepositories: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private let gitHubService: GitHubService

    init(gitHubService: GitHubService = GitHubService()) {
        self.gitHubService = gitHubService
    }

    func fetchRepositories() {
        gitHubService.fetchRepositories()
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.isLoadingRepositories = true
                }
            )
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingRepositories = false
                    print(completion)
                },
                receiveValue: { [weak self] repositories in
                    self?.repositories = repositories
                }
            )
            .store(in: &cancellables)
    }
}

