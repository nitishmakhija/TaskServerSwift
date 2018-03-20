//
//  OpenAPIMediaType.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Each Media Type Object provides schema and examples for the media type identified by its key.
class OpenAPIMediaType: Codable {
    var ref: String? // TODO: This should be in json as $ref

    var schema: OpenAPISchema?
    var example: String?
    var examples: [String: OpenAPIExample]?
    var encoding: [String: OpenAPIEncoding]?
}
