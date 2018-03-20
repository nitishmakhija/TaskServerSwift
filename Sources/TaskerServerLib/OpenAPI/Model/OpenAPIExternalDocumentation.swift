//
//  OpenAPIExternalDocumentation.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Allows referencing an external resource for extended documentation.
class OpenAPIExternalDocumentation: Codable {
    var url: String
    var description: String?

    init(url: String, description: String? = nil) {
        self.url = url
        self.description = description
    }
}
