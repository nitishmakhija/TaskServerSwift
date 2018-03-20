//
//  OpenAPIServerVariable.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// An object representing a Server Variable for server URL template substitution.
class OpenAPIServerVariable: Codable {
    var `default`: String
    var `enum`: [String]?
    var description: String?

    init(default: String) {
        self.`default` = `default`
    }
}
