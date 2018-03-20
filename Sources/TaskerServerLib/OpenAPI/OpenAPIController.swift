//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP

public class OpenAPIController {

    public func getRoute() -> Route {
        let route = Route(method: .get, uri: "/openapi", handler: all)
        return route
    }

    private func all(request: HTTPRequest, response: HTTPResponse) {

        // Info
        let apiInfo = OpenAPIInfo(
            title: "Tasker Server",
            version: "1.0.0",
            description: "This is a sample server for a pet store.",
            termsOfService: "http://example.com/terms/",
            contact: OpenAPIContact(),
            license: OpenAPILicence(name: "MIT")
        )

        // Tags
        var tags: [OpenAPITag] = []
        let usersTag = OpenAPITag(name: "Users", description: "Controller where we can manage users.")
        
        tags.append(usersTag)

        // Paths
        var paths: [String: OpenAPIPathItem] = [:]

        // Paths : Action 1
        let getAllUsers = OpenAPIPathItem()
        getAllUsers.get = OpenAPIOperation()
        getAllUsers.get?.summary = "Getting all users"
        getAllUsers.get?.description = "Getting all users from server"
        getAllUsers.get?.tags = ["Users"]
        paths["/users"] = getAllUsers

        // Paths : Action 2
        let getUser = OpenAPIPathItem()
        getUser.get = OpenAPIOperation()
        getUser.get?.summary = "Getting specific user"
        getUser.get?.description = "Getting specific user from server by his id"
        getUser.get?.tags = ["Users"]
        paths["/users/{id}"] = getUser

        // Root specification
        let apiSpecification = OpenAPIDocument(openapi: "swifter", info: apiInfo, paths: paths, tags: tags)
        response.sendJson(apiSpecification)
    }
}
