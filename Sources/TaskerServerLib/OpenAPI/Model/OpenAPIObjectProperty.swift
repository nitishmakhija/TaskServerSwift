//
//  OpenAPIObjectProperty.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 21.03.2018.
//

import Foundation

class OpenAPIObjectProperty: Encodable {
    var type: String

    init(type: String) {
        self.type = type
    }
}
