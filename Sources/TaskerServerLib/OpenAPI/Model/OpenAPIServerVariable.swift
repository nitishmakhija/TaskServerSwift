//
//  OpenAPIServerVariable.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// An object representing a Server Variable for server URL template substitution.
class OpenAPIServerVariable: Encodable {
    var defaultValue: String
    var enumValues: [String]?
    var description: String?

    init(defaultValue: String) {
        self.defaultValue = defaultValue
    }

    private enum CodingKeys: String, CodingKey {
        case defaultValue = "default"
        case enumValues = "enum"
        case description
    }
}
