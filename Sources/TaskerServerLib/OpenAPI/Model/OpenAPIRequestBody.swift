//
//  OpenAPIRequestBody.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single request body.
class OpenAPIRequestBody: Codable {
    var ref: String? // TODO: This should be in json as $ref

    var description: String?
    var content: [String: OpenAPIMediaType] = [:]
    var required: Bool = false
}
