//
//  OpenAPIXML.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// A metadata object that allows for more fine-tuned XML model definitions.
class OpenAPIXML: Codable {
    var name: String?
    var namespace: String?
    var prefix: String?
    var attribute: Bool = false
    var wrapped: Bool = false
}
