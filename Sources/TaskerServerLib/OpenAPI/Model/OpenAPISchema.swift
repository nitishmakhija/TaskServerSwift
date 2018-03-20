//
//  OpenAPISchema.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// The Schema Object allows the definition of input and output data types.
class OpenAPISchema: Codable {
    var ref: String? // TODO: This should be in json as $ref

    var nullable: Bool = false
    var discriminator: OpenAPIDiscriminator?
    var readOnly: Bool = false
    var writeOnly: Bool = false
    var xml: OpenAPIXML?
    var externalDocs: OpenAPIExternalDocumentation?
    var example: String?
    var deprecated: Bool = false

    init(ref: String) {
        self.ref = ref
    }
}
