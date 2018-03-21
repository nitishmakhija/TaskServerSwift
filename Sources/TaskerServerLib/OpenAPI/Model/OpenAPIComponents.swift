//
//  OpenAPIComponents.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Holds a set of reusable objects for different aspects of the OAS. All objects defined within
// the components object will have no effect on the API unless they are explicitly referenced
// from properties outside the components object.
class OpenAPIComponents: Encodable {
    var schemas: [String: OpenAPISchema]?
    var responses: [String: OpenAPIResponse]?
    var parameters: [String: OpenAPIParameter]?
    var examples: [String: OpenAPIExample]?
    var requestBodies: [String: OpenAPIRequestBody]?
    var headers: [String: OpenAPIHeader]?
    var securitySchemes: [String: OpenAPISecurityScheme]?
    var links: [String: OpenAPILink]?
    var callbacks: [String: [String: OpenAPIPathItem]]?
}
