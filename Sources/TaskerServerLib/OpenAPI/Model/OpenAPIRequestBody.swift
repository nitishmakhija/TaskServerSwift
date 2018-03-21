//
//  OpenAPIRequestBody.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single request body.
class OpenAPIRequestBody: Encodable {
    var ref: String?

    var description: String?
    var content: [String: OpenAPIMediaType] = [:]
    var required: Bool = false

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case description
        case content
        case required
    }
}
