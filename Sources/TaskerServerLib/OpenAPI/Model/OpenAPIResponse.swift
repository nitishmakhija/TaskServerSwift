//
//  OpenAPIResponse.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single response from an API Operation, including design-time,
// static links to operations based on the response.
class OpenAPIResponse: Encodable {
    var ref: String?

    var description: String
    var headers: [String: OpenAPIHeader]?
    var content: [String: OpenAPIMediaType]?
    var links: [String: OpenAPILink]?

    init(description: String) {
        self.description = description
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case description
        case headers
        case content
        case links
    }
}
