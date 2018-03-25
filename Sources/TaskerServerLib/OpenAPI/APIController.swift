//
//  APIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class APIController {
    var name: String
    var description: String
    var externalDocs: OpenAPIExternalDocumentation? = nil
    var actions: [APIAction]

    init(name: String, description: String, externalDocs: OpenAPIExternalDocumentation? = nil, actions: [APIAction] = []) {
        self.name = name
        self.description = description
        self.externalDocs = externalDocs
        self.actions = actions
    }
}
