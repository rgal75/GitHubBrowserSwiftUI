//
//  ConfigurableResponse.swift
//  SUIGitHubBrowser
//
//  Created by Richard Gal on 2025. 01. 04..
//

import Foundation

enum ConfigurableResponse<R, Error> {
    case success(R)
    case failure(Error)
    case pending
}
