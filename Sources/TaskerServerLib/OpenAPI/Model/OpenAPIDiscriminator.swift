//
//  OpenAPIDiscriminator.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// When request bodies or response payloads may be one of a number of different schemas,
// a discriminator object can be used to aid in serialization, deserialization, and validation.
// The discriminator is a specific object in a schema which is used to inform the consumer
// of the specification of an alternative schema based on the value associated with it.
class OpenAPIDiscriminator: Codable {
    var propertyName: String
    var mapping: [String: String]?

    init(propertyName: String) {
        self.propertyName = propertyName
    }
}
