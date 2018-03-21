//
//  OpenAPIOAuthFlows.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Allows configuration of the supported OAuth Flows.
class OpenAPIOAuthFlows: Encodable {
    var implicit: OpenAPIOAuthFlow?
    var password: OpenAPIOAuthFlow?
    var clientCredentials: OpenAPIOAuthFlow?
    var authorizationCode: OpenAPIOAuthFlow?
}
