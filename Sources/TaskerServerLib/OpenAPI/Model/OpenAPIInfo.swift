//
//  OpenAPIInfo.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The object provides metadata about the API. The metadata MAY be used by the clients if needed,
// and MAY be presented in editing or documentation generation tools for convenience.
class OpenAPIInfo : Encodable {
    var title: String
    var version: String
    var description: String?
    var termsOfService: String?
    var contact: OpenAPIContact?
    var license: OpenAPILicence?

    init(title: String, version: String, description: String? = nil, termsOfService: String? = nil,
         contact: OpenAPIContact? = nil, license: OpenAPILicence? = nil) {
        self.title = title
        self.version = version

        self.description = description
        self.termsOfService = termsOfService
        self.contact = contact
        self.license = license
    }
}
