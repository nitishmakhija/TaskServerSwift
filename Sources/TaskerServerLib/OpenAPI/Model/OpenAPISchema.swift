//
//  OpenAPISchema.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The Schema Object allows the definition of input and output data types.
class OpenAPISchema: Encodable {
    var ref: String?

    var type: String?
    var required: [String]?
    var properties: [String: OpenAPIObjectProperty]?

    init() {
    }

    init(ref: String) {
        self.ref = ref
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type
        case required
        case properties
    }
}
