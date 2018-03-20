//
//  OpenAPIExample.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Object with example description.
class OpenAPIExample: Codable {
    var ref: String? // TODO: This should be in json as $ref

    var summary: String?
    var description: String?
    var value: String?
    var externalValue: String?
}
