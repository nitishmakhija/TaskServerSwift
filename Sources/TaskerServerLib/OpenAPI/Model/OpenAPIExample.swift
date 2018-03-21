//
//  OpenAPIExample.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Object with example description.
class OpenAPIExample: Encodable {
    var ref: String?

    var summary: String?
    var description: String?
    var value: String?
    var externalValue: String?

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case summary
        case description
        case value
        case externalValue
    }
}
