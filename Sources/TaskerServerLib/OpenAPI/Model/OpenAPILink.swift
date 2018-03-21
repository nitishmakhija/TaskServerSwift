//
//  OpenAPILink.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The Link object represents a possible design-time link for a response.
// The presence of a link does not guarantee the caller's ability to successfully invoke it,
// rather it provides a known relationship and traversal mechanism between responses and other operations.
class OpenAPILink: Encodable {
    var ref: String? // TODO: This should be in json as $ref

    var operationRef: String?
    var operationId: String?
    var parameters: [String: String]?
    var requestBody: String?
    var description: String?
    var server: OpenAPIServer?

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case operationRef
        case operationId
        case parameters
        case requestBody
        case description
        case server
    }
}
