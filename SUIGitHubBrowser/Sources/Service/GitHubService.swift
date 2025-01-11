//
//  GitHubService.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2024. 12. 01..
//

import Combine
import Foundation
import GitHubClient
import HTTPTypes
import OpenAPIRuntime
import OpenAPIURLSession
import os

enum GitHubError: Error {
    case general, timeout
}

@Observable
class GitHubService {
    private static let log = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: GitHubService.self)
    )
    private let client: Client
    
    private init(client: Client) {
        self.client = client
    }
    
    static func create() -> GitHubService {
        print("Creating real GitHubService...")
        return GitHubService(client: Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        ))
    }
    
    static func createNull(responses: [ConfigurableResponse<[GitHubRepository], Error>]) -> GitHubService {
        print("Creating nulled GitHubService...")
        let apiResponses: [ConfigurableResponse<(HTTPResponse, HTTPBody?), Error>] = responses
            .map { (serviceResponse: ConfigurableResponse<[GitHubRepository], any Error>) in
                switch serviceResponse {
                case .success(let repositories):
                    let schemaItems: [Components.Schemas.repo_hyphen_search_hyphen_result_hyphen_item] = repositories
                        .map { (repo: GitHubRepository) in
                            Components.Schemas.repo_hyphen_search_hyphen_result_hyphen_item(
                                id: repo.id,
                                node_id: "TODO",
                                name: repo.name,
                                full_name: "TODO",
                                _private: false,
                                html_url: "TODO",
                                fork: false,
                                url: repo.url.absoluteString,
                                created_at: Date(),
                                updated_at: Date(),
                                pushed_at: Date(),
                                size: 0,
                                stargazers_count: 0,
                                watchers_count: 0,
                                forks_count: 0,
                                open_issues_count: 0,
                                default_branch: "TODO",
                                score: 0.0,
                                forks_url: "TODO",
                                keys_url: "TODO",
                                collaborators_url: "TODO",
                                teams_url: "TODO",
                                hooks_url: "TODO",
                                issue_events_url: "TODO",
                                events_url: "TODO",
                                assignees_url: "TODO",
                                branches_url: "TODO",
                                tags_url: "TODO",
                                blobs_url: "TODO",
                                git_tags_url: "TODO",
                                git_refs_url: "TODO",
                                trees_url: "TODO",
                                statuses_url: "TODO",
                                languages_url: "TODO",
                                stargazers_url: "TODO",
                                contributors_url: "TODO",
                                subscribers_url: "TODO",
                                subscription_url: "TODO",
                                commits_url: "TODO",
                                git_commits_url: "TODO",
                                comments_url: "TODO",
                                issue_comment_url: "TODO",
                                contents_url: "TODO",
                                compare_url: "TODO",
                                merges_url: "TODO",
                                archive_url: "TODO",
                                downloads_url: "TODO",
                                issues_url: "TODO",
                                pulls_url: "TODO",
                                milestones_url: "TODO",
                                notifications_url: "TODO",
                                labels_url: "TODO",
                                releases_url: "TODO",
                                deployments_url: "TODO",
                                git_url: "TODO",
                                ssh_url: "TODO",
                                clone_url: "TODO",
                                svn_url: "TODO",
                                forks: 0,
                                open_issues: 0,
                                watchers: 0,
                                has_issues: false,
                                has_projects: false,
                                has_pages: false,
                                has_wiki: false,
                                has_downloads: false,
                                archived: false,
                                disabled: false
                            )
                        }
                    let jsonPayload = Operations.search_sol_repos.Output.Ok.Body.jsonPayload(
                        total_count: 1,
                        incomplete_results: false,
                        items: schemaItems
                    )

                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.dateEncodingStrategy = .iso8601
                    let apiResponseData = try! jsonEncoder.encode(jsonPayload)
                    let apiResponseBody: HTTPBody? = HTTPBody(apiResponseData)
                    return .success((HTTPResponse(status: .ok), apiResponseBody))
                case .failure(let error):
                    return .failure(error)
                case .pending:
                    return .pending
                }
            }
        return GitHubService(client: Client(
            serverURL: try! Servers.Server1.url(),
            transport: StubbedClientTransport(responses: apiResponses)
        ))
    }
    
    func fetchRepositories(searchText: String) -> AnyPublisher<[GitHubRepository], Error> {
        print("Fetching repositories...")
        return Future { [weak self] promise in
            Task {
                do {
                    let response = try await self?.client.search_sol_repos(query: .init(q: searchText))
                    switch response {
                    case .ok(let okResponse):
                        let json = try okResponse.body.json
                        promise(.success(json.items.map({ item in
                            return GitHubRepository(id: item.id, name: item.name, url: URL(string: item.url)!)
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

private actor StubbedClientTransport: ClientTransport {
    private var responses: [ConfigurableResponse<(HTTPResponse, HTTPBody?), Error>]
    
    init(responses: [ConfigurableResponse<(HTTPResponse, HTTPBody?), Error>]) {
        self.responses = responses
    }
    
    func send(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPResponse, HTTPBody?) {
        print("Sending search request: \(request)")
        let stubbedResponse = responses.isEmpty ? .pending : responses.removeFirst()

        switch stubbedResponse {
        case .success(let apiResponse):
            print("Received search response: \(apiResponse)")
            return apiResponse
        case .failure(error: let error):
            throw error
        case .pending:
            try await Task.sleep(for: .seconds(2))
            throw GitHubError.timeout
        }
    }
}
