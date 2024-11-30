import ProjectDescription

let project = Project(
    name: "SUIGitHubBrowser",
//    packages: [
//        .remote(
//            url: "https://github.com/apple/swift-openapi-generator",
//            requirement: .upToNextMajor(from: "1.4.0")
//        )
//    ],
    targets: [
        .target(
            name: "SUIGitHubBrowser",
            destinations: .iOS,
            product: .app,
            bundleId: "hu.galiasys.SUIGitHubBrowser",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["SUIGitHubBrowser/Sources/**"],
            resources: ["SUIGitHubBrowser/Resources/**"],
            dependencies: [
                .target(name: "GitHubClient")
            ]
        ),
        .target(
            name: "SUIGitHubBrowserTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "hu.galiasys.SUIGitHubBrowserTests",
            infoPlist: .default,
            sources: ["SUIGitHubBrowser/Tests/**"],
            resources: [],
            dependencies: [.target(name: "SUIGitHubBrowser")]
        ),
        .target(
            name: "GitHubClient",
            destinations: .iOS,
            product: .framework,
            bundleId: "hu.galiasys.GitHubClient",
            sources: ["GitHubClient/Sources/**"],
            resources: [.glob(
                pattern: "GitHubClient/Resources/**",
                excluding: [
                    "GitHubClient/Resources/*.yaml"
                ]
            )], // ["GitHubClient/Resources/**"],
            scripts: [
                .pre(
                    script: """
                            pushd GitHubClient
                            /usr/bin/make generate
                            popd
                            """,
                    name: "Generate API Client",
                    inputPaths: [
                        "GitHubClient/Resources/openapi.yaml",
                        "GitHubClient/Resources/openapi-generator-config.yaml"
                    ],
                    outputPaths: [
                        "GitHubClient/Sources/Generated/Types.swift",
                        "GitHubClient/Sources/Generated/Client.swift"
                    ]
                )
            ],
            dependencies: [
//                .package(product: "swift-openapi-generator", type: .plugin),
                .external(name: "OpenAPIRuntime"),
                .external(name: "OpenAPIURLSession")
            ]
        )
    ]
)
