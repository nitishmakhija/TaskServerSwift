//
//  OpenAPIContact.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Contact information for the exposed API.
class OpenAPIContact : Codable {
    var name: String?
    var url: URL?
    var email: String?

    init(name: String?, email: String? = nil, url: URL? = nil) {
        self.name = name
        self.email = email
        self.url = url
    }
}
