//
//  APIParameter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class APIParameter {
    var name: String
    var parameterLocation: OpenAPIParameterLocation = OpenAPIParameterLocation.path
    var description: String?
    var required: Bool = false
    var deprecated: Bool = false
    var allowEmptyValue: Bool = false

    init(
        name: String,
        parameterLocation: OpenAPIParameterLocation = OpenAPIParameterLocation.path,
        description: String? = nil,
        required: Bool = false,
        deprecated: Bool = false,
        allowEmptyValue: Bool = false
        ) {
        self.name = name
        self.parameterLocation = parameterLocation
        self.description = description
        self.required = required
        self.deprecated = deprecated
        self.allowEmptyValue = allowEmptyValue
    }
}
