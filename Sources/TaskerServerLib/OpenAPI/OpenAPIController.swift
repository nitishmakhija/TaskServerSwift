//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP

public class  OpenAPIBuilder {

    var apiInfo: OpenAPIInfo
    var paths: [String: OpenAPIPathItem] = [:]
    var tags: [OpenAPITag] = []

    init(title: String, version: String, description: String, termsOfService: String? = nil) {
        self.apiInfo = OpenAPIInfo(
            title: title,
            version: version,
            description: description,
            termsOfService: termsOfService
        )
    }

    func addContact(name: String?, email: String? = nil, url: URL? = nil) -> OpenAPIBuilder {
        let apiContact = OpenAPIContact(name: name, email: email, url: url)
        apiInfo.contact = apiContact

        return self
    }

    func addController(name: String, description: String, externalDocs: OpenAPIExternalDocumentation? = nil) -> OpenAPIBuilder {

        let tag = OpenAPITag(name: name, description: description, externalDocs: externalDocs)
        tags.append(tag)

        return self
    }

    func addAction(controllerName: String, method: HTTPMethod, route: String, summary: String, description: String) -> OpenAPIBuilder {

        let getAllUsers = OpenAPIPathItem()

        let openAPIOperation = OpenAPIOperation()
        openAPIOperation.summary = summary
        openAPIOperation.description = description
        openAPIOperation.tags = [controllerName]

        switch method {
        case .get:
            getAllUsers.get = openAPIOperation
        case .post:
            getAllUsers.post = openAPIOperation
        case .put:
            getAllUsers.put = openAPIOperation
        case .delete:
            getAllUsers.delete = openAPIOperation
        case .patch:
            getAllUsers.patch = openAPIOperation
        case .options:
            getAllUsers.options = openAPIOperation
        case .trace:
            getAllUsers.trace = openAPIOperation
        case .head:
            getAllUsers.head = openAPIOperation
        default:
            print("Not implemented")
        }

        paths[route] = getAllUsers
        return self
    }

    func build() throws -> OpenAPIDocument {
        return OpenAPIDocument(info: apiInfo, paths: paths, tags: nil)
    }
}

public class OpenAPIController {

    public func getRoute() -> Route {
        let route = Route(method: .get, uri: "/openapi", handler: all)
        return route
    }

    private func cos() {

        let openAPIBuilder = OpenAPIBuilder(
            title: "Tasker server",
            version: "1.0.0",
            description: "This is a sample server for a pet store.",
            termsOfService: "http://example.com/terms/"
        )
        .addContact(name: "Marcin Czachurski", email: "marcincz@email.com", url: URL(string: "http://medium.com/@mczachurski"))
        .addController(name: "Users", description: "Controller where we can manage users.")
        .addController(name: "Tasks", description: "Controller where we can manage tasks.")
        .addAction(
            controllerName: "Users",
            method: .get,
            route: "/users",
            summary: "Getting all users",
            description: "Action for getting all users from server"
        )
        .addAction(
            controllerName: "Tasks",
            method: .get,
            route: "/users",
            summary: "Getting all users",
            description: "Action for getting all users from server"
        )

        do {
            _ = try openAPIBuilder.build()
        } catch {
            print("Error...")
        }
    }

    private func all(request: HTTPRequest, response: HTTPResponse) {

//        // Info
//        let apiInfo = OpenAPIInfo(
//            title: "Tasker Server",
//            version: "1.0.0",
//            description: "This is a sample server for a pet store.",
//            termsOfService: "http://example.com/terms/",
//            contact: OpenAPIContact(),
//            license: OpenAPILicence(name: "MIT")
//        )
//
//        // Tags
//        var tags: [OpenAPITag] = []
//        let usersTag = OpenAPITag(name: "Users", description: "Controller where we can manage users.")
//
//        tags.append(usersTag)
//
//        // Paths
//        var paths: [String: OpenAPIPathItem] = [:]
//
//        // Paths : Action 1
//        let getAllUsers = OpenAPIPathItem()
//        getAllUsers.get = OpenAPIOperation()
//        getAllUsers.get?.summary = "Getting all users"
//        getAllUsers.get?.description = "Getting all users from server"
//        getAllUsers.get?.tags = ["Users"]
//        paths["/users"] = getAllUsers
//
//        // Paths : Action 2
//        let getUser = OpenAPIPathItem()
//        getUser.get = OpenAPIOperation()
//        getUser.get?.summary = "Getting specific user"
//        getUser.get?.description = "Getting specific user from server by his id"
//        getUser.get?.tags = ["Users"]
//        paths["/users/{id}"] = getUser
//
//        // Root specification
//        let apiSpecification = OpenAPIDocument(openapi: "swifter", info: apiInfo, paths: paths, tags: tags)
//        response.sendJson(apiSpecification)
    }
}
