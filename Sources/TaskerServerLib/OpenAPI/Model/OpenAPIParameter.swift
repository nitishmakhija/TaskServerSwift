//
//  OpenAPIParameter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single operation parameter.
// A unique parameter is defined by a combination of a name and location.
class OpenAPIParameter: Codable {
    var ref: String? // TODO: This should be in json as $ref

    // TODO: Here we have only fixed fields (documentation describes more).
    var name: String?
    var `in`: OpenAPIParameterLocation = OpenAPIParameterLocation.path
    var description: String?
    var required: Bool = false
    var deprecated: Bool = false
    var allowEmptyValue: Bool = false

    init(name: String) {
        self.name = name
    }

    init(ref: String) {
        self.ref = ref
    }
}
