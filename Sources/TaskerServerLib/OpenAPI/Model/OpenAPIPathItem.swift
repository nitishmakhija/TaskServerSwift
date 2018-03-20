//
//  OpenAPIPath.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes the operations available on a single path. A Path Item MAY be empty, due to ACL constraints.
// The path itself is still exposed to the documentation viewer but they will not know which operations
// and parameters are available.
class OpenAPIPathItem : Codable {
    var summary: String?
    var description: String?
    var ref: String? // TODO: This should be in json as $ref

    var get: OpenAPIOperation?
    var put: OpenAPIOperation?
    var post: OpenAPIOperation?
    var delete: OpenAPIOperation?
    var options: OpenAPIOperation?
    var head: OpenAPIOperation?
    var patch: OpenAPIOperation?
    var trace: OpenAPIOperation?

    var servers: [OpenAPIServer]?
    var parameters: [OpenAPIParameter]?
}
