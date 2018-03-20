//
//  OpenAPIDocument.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation

// This is the root document object of the OpenAPI document.
class OpenAPIDocument : Codable {
    var openapi: String
    var info: OpenAPIInfo
    var paths: [String: OpenAPIPathItem]
    var servers: [OpenAPIServer]?
    var tags: [OpenAPITag]?
    var components: OpenAPIComponents?
    var security: [String: [String]]?
    var externalDocs: OpenAPIExternalDocumentation?

    init(openapi: String, info: OpenAPIInfo, paths: [String: OpenAPIPathItem], servers: [OpenAPIServer]? = nil, tags: [OpenAPITag]? = nil) {
        self.openapi = openapi
        self.info = info
        self.paths = paths
        self.servers = servers
        self.tags = tags
    }
}
