import Foundation
import GitHubClient
import OpenAPIURLSession
import Testing

final class GitHubServiceTests {
    @Test("2 + 2 = 4")
    func addition() async throws {
        #expect(2 + 2 == 4)
    }
    
    @Test func search() async throws {
        let client = Client(
            serverURL: try Servers.Server1.url(), // URL(string: "https://api.github.com")!,
            transport: URLSessionTransport()
        )
        
        let response = try await client.search_sol_repos(query: .init(q: "rxswift"))
        
        print(try response.ok.body.json.items)
    }
}
