//
//  RepositoryListViewModel.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2024. 12. 01..
//

import Foundation
import Combine
import Observation
import HTTPTypes

@Observable
class RepositoryListViewModel {
    var repositories: [GitHubRepository] = []
    var isLoadingRepositories: Bool = false
    let searchText: PassthroughSubject<String, Never> = .init()

    private var cancellables: Set<AnyCancellable> = []
    private let gitHubService: GitHubService

    private init(gitHubService: GitHubService) {
        self.gitHubService = gitHubService
    }
    
    static func create() -> RepositoryListViewModel {
        return RepositoryListViewModel(gitHubService: GitHubService.create())
    }
    
    static func createNull(repositories: [ConfigurableResponse<[GitHubRepository], Error>]) -> RepositoryListViewModel {
        print("RepositoryListViewModel.createNull")
        return RepositoryListViewModel(
            gitHubService: GitHubService.createNull(
                responses: repositories
            )
        )
    }

    func listen() {
        print("Listening...")
        self.searchText
            .filter { searchText in
                return searchText.count >= 3
            }
            .throttle(for: .milliseconds(500), scheduler: RunLoop.main, latest: true)
            .flatMap { [weak self] (searchText: String) -> AnyPublisher<[GitHubRepository], Error> in
                guard let self else { return Empty<[GitHubRepository], Error>(completeImmediately: false).eraseToAnyPublisher() }
                isLoadingRepositories = true
                return gitHubService.fetchRepositories(searchText: searchText)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { [weak self] repositories in
                    self?.isLoadingRepositories = false
                    self?.repositories = repositories
                }
            )
            .store(in: &cancellables)
    }
}

