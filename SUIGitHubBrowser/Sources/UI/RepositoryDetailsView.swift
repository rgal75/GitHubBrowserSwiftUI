//
//  RepositoryDetailsView.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2025. 01. 03..
//

import SwiftUI

struct RepositoryDetailsView: View {
    let repository: GitHubRepository
    
    var body: some View {
        Button {
            // TODO:
        } label: {
            Text("Details")
        }
        .navigationTitle(repository.name)
    }
}

#Preview {
    NavigationView {
        RepositoryDetailsView(
            repository: GitHubRepository(
                id: 0,
                name: "Preview Repo",
                url: URL(string: "https://index.hu")!
            )
        )
    }
}
