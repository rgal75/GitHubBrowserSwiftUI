import SwiftUI

public struct RepositoryListView: View {
    @Environment(RepositoryListViewModel.self) var viewModel
    @State private var searchText: String = ""

    public var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.repositories) { item in
                    NavigationLink {
                        RepositoryDetailsView(repository: item)
                    } label: {
                        Text(item.name)
                    }

                }
                .searchable(
                    text: $searchText,
                    prompt: "Enter a repository name"
                )
                .refreshable {
                    print("Refreshing...")
                    viewModel.searchText.send(searchText)
                }
                if viewModel.isLoadingRepositories {
                    ProgressView()
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                viewModel.listen()
            }
            .onChange(of: searchText) {
                print(searchText)
                viewModel.searchText.send(searchText)
            }
        }
    }
}

#Preview {
    RepositoryListView()
        .environment(
            RepositoryListViewModel.createNull(
                repositories: [
                    .success([
                        GitHubRepository(id: 1, name: "1st. Repo", url: URL(string: "https://github.com/1st/repo")!)
                    ])
                ]
            )
        )
}


