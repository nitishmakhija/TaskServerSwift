//
//  APIServer.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class APIServer {

    var url: String
    var description: String?
    var variables: [String: OpenAPIServerVariable]?

    init(url: String, description: String? = nil, variables: [String: OpenAPIServerVariable]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}
