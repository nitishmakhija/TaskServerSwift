//
//  OpenAPITagsBuilder.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

class OpenAPITagsBuilder {

    let controllers: [APIController]

    init(controllers: [APIController]) {
        self.controllers = controllers
    }

    func build() -> [OpenAPITag] {

        var tags: [OpenAPITag] = []
        for controller in controllers {
            let tag = OpenAPITag(name: controller.name, description: controller.description, externalDocs: controller.externalDocs)
            tags.append(tag)
        }

        return tags
    }
}
