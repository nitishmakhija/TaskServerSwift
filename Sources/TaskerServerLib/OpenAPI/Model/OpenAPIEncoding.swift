//
//  OpenAPIEncoding.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// A single encoding definition applied to a single schema property.
class OpenAPIEncoding: Encodable {
    var contentType: String?
    var headers: [String: OpenAPIHeader]?
    var style: String?
    var explode: Bool = false
    var allowReserved: Bool = false
}
