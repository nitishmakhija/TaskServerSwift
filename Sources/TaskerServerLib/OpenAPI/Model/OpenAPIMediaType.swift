//
//  OpenAPIMediaType.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Each Media Type Object provides schema and examples for the media type identified by its key.
class OpenAPIMediaType: Encodable {
    var ref: String?

    var schema: OpenAPISchema?
    var example: String?
    var examples: [String: OpenAPIExample]?
    var encoding: [String: OpenAPIEncoding]?

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case schema
        case example
        case examples
        case encoding
    }
}
