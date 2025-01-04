import SwiftUI

@main
struct SUIGitHubBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoryListView()
                .environment(RepositoryListViewModel.create())
        }
    }
}
