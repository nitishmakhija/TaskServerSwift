//
//  OpenAPILicence.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// License information for the exposed API.
class OpenAPILicence : Codable {
    var name: String
    var url: String?

    init(name: String) {
        self.name = name
    }
}
