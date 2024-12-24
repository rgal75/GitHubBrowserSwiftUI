import SwiftUI

public struct ContentView: View {
    @StateObject private var viewModel = RepositoryListViewModel()

    public var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.repositories) { item in
                    Text(item.name)
                }
                if viewModel.isLoadingRepositories {
                    ProgressView()
                }
            }
            .navigationTitle("Items")
            .onAppear {
                viewModel.fetchRepositories()
            }
        }
    }
}

#Preview {
    ContentView()
}


