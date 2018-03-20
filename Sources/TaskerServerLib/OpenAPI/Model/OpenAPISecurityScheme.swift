//
//  OpenAPISecurityScheme.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Defines a security scheme that can be used by the operations. Supported schemes are HTTP authentication,
// an API key (either as a header or as a query parameter), OAuth2's common flows (implicit, password,
// application and access code) as defined in RFC6749, and OpenID Connect Discovery.
class OpenAPISecurityScheme: Codable {
    var ref: String? // TODO: This should be in json as $ref

    var string: String?
    var description: String?
    var name: String?
    var `in`: OpenAPIParameterLocation = OpenAPIParameterLocation.path
    var scheme: String?
    var bearerFormat: String?
    var flows: OpenAPIOAuthFlows?
    var openIdConnectUrl: String?
}
