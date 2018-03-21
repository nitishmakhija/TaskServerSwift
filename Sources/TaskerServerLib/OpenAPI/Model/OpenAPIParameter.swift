//
//  OpenAPIParameter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Describes a single operation parameter.
// A unique parameter is defined by a combination of a name and location.
class OpenAPIParameter: Encodable {
    var ref: String?

    var name: String?
    var parameterLocation: OpenAPIParameterLocation = OpenAPIParameterLocation.path
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

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case name
        case parameterLocation = "in"
        case description
        case required
        case deprecated
        case allowEmptyValue
    }
}
