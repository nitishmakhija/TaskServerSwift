//
//  OpenAPIDocument.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation

// This is the root document object of the OpenAPI document.
class OpenAPIDocument : Codable {
    let openapi = "3.0.1"

    var info: OpenAPIInfo
    var paths: [String: OpenAPIPathItem]
    var servers: [OpenAPIServer]?
    var tags: [OpenAPITag]?
    var components: OpenAPIComponents?
    var security: [String: [String]]?
    var externalDocs: OpenAPIExternalDocumentation?

    init(info: OpenAPIInfo, paths: [String: OpenAPIPathItem], servers: [OpenAPIServer]? = nil, tags: [OpenAPITag]? = nil) {
        self.info = info
        self.paths = paths
        self.servers = servers
        self.tags = tags
    }
}
