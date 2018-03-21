//
//  OpenAPIOperation.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single API operation on a path.
class OpenAPIOperation: Encodable {
    var summary: String?
    var description: String?
    var tags: [String]?

    var externalDocs: OpenAPIExample?
    var operationId: String?
    var parameters: [OpenAPIParameter]?
    var requestBody: OpenAPIRequestBody?
    var responses: [String: OpenAPIResponse]?
    var callbacks: [String: [String: OpenAPIPathItem]]?
    var deprecated: Bool = false
    var security: [String: [String]]?
    var servers: [OpenAPIServer]?
}
