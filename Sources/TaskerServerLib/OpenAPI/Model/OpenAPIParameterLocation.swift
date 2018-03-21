//
//  OpenAPIParameterLocation.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Enum with possible parameters locations.
enum OpenAPIParameterLocation: String, Encodable {
    case query = "query"
    case header = "header"
    case path = "path"
    case cookie = "cookie"
}
