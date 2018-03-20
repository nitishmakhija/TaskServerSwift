//
//  OpenAPIOAuthFlow.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Configuration details for a supported OAuth Flow.
class OpenAPIOAuthFlow: Codable {
    var authorizationUrl: String?
    var tokenUrl: String?
    var refreshUrl: String?
    var scopes: [String: String]?
}
