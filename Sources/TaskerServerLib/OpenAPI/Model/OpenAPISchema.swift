//
//  OpenAPISchema.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The Schema Object allows the definition of input and output data types.
class OpenAPISchema: Encodable {

    public private(set) var ref: String?
    public private(set) var type: String?
    public private(set) var required: [String]?
    public private(set) var properties: [String: OpenAPIObjectProperty]?

    init(ref: String) {
        self.ref = ref
    }
    
    init(type: String? = nil, required: [String]? = nil, properties: [(name: String, type: OpenAPIObjectProperty)]? = nil) {
        self.type = type
        self.required = required

        if let typeProperies = properties {
            self.properties = [:]
            for property in typeProperies {
                self.properties![property.name] = property.type
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type
        case required
        case properties
    }
}
