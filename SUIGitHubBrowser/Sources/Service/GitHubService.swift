//
//  GitHubService.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2024. 12. 01..
//

import Combine
import Foundation
import GitHubClient
import OpenAPIURLSession

enum GitHubError: Error {
    case general
}
class GitHubService {
    func fetchRepositories() -> AnyPublisher<[GitHubRepository], Error> {
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        return Future { promise in
            Task {
                do {
                    let response = try await client.search_sol_repos(query: .init(q: "rxswift"))
                    switch response {
                    case .ok(let okResponse):
                        promise(.success(try okResponse.body.json.items.map({ item in
                            return GitHubRepository(id: item.id, name: item.name)
                        })))
                    default:
                        promise(.failure(GitHubError.general))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
