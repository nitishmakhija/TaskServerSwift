//
//  OpenAPIServer.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// An object representing a Server.
class OpenAPIServer: Encodable {
    var url: String
    var description: String?
    var variables: [String: OpenAPIServerVariable]?

    init(url: String) {
        self.url = url
    }
}
