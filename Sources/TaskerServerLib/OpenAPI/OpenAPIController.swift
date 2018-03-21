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
    var components: OpenAPIComponents = OpenAPIComponents()

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

    func addController(name: String, description: String, externalDocs: OpenAPIExternalDocumentation? = nil,
                       withActions actions: [(method: HTTPMethod, route: String, summary: String?, description: String?)]) -> OpenAPIBuilder {

        let tag = OpenAPITag(name: name, description: description, externalDocs: externalDocs)
        tags.append(tag)

        for action in actions {
            self.addAction(controllerName: name, method: action.method, route: action.route, summary: action.summary, description: action.description)
        }

        return self
    }

    private func addAction(controllerName: String, method: HTTPMethod, route: String, summary: String? = nil, description: String? = nil) {

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

        let parameter = OpenAPIParameter(name: "id")
        parameter.parameterLocation = .query
        parameter.required = true
        parameter.description = "Id number of object"

        openAPIOperation.parameters = []
        openAPIOperation.parameters?.append(parameter)

        openAPIOperation.requestBody = OpenAPIRequestBody()
        openAPIOperation.requestBody?.description = "Request body description"

        let mediaType = OpenAPIMediaType()
        mediaType.example = "Example of something"
        mediaType.schema = OpenAPISchema(ref: "#/components/schemas/User")

        openAPIOperation.requestBody?.content = ["application/json": mediaType]

        // openAPIOperation.requestBody =
        // openAPIOperation.responses =

        paths[route] = getAllUsers
    }

    func build() throws -> OpenAPIDocument {

        let openAPISchema = OpenAPISchema()
        openAPISchema.properties = [:]
        openAPISchema.properties!["id"] = OpenAPIObjectProperty(type: "string")
        openAPISchema.properties!["name"] = OpenAPIObjectProperty(type: "string")
        openAPISchema.type = "object"
        openAPISchema.required = ["id"]

        self.components.schemas = [:]
        self.components.schemas!["User"] = openAPISchema

        return OpenAPIDocument(info: apiInfo, paths: paths, tags: nil, components: self.components)
    }
}

public class OpenAPIController {

    public func getRoute() -> Route {
        let route = Route(method: .get, uri: "/openapi", handler: all)
        return route
    }

    private func all(request: HTTPRequest, response: HTTPResponse) {
        let openAPIDocument = self.generateOpenAPIDocument()
        response.sendJson(openAPIDocument)
    }

    private func generateOpenAPIDocument() -> OpenAPIDocument? {

        let openAPIBuilder = OpenAPIBuilder(
            title: "Tasker server",
            version: "1.0.0",
            description: "This is a sample server for a pet store.",
            termsOfService: "http://example.com/terms/"
        )
        .addContact(name: "Marcin Czachurski", email: "marcincz@email.com", url: URL(string: "http://medium.com/@mczachurski"))
        .addController(name: "Users", description: "Controller where we can manage users", withActions: [
                (method: .get, route: "/users", summary: "Getting all users", description: "Action for getting all users from server"),
                (method: .get, route: "/users/{id}", summary: "Getting user by id", description: "Action for getting specific user from server")
            ]
        )
        .addController(name: "Tasks", description: "Controller where we can manage tasks", withActions: [
                (method: .get, route: "/tasks", summary: "Getting all tasks", description: "Action for getting all tasks from server"),
                (method: .get, route: "/tasks/{id}", summary: "Getting task by id", description: "Action for getting specific task from server")
            ]
        )
        .addController(name: "Health", description: "Controller where we can check health", withActions: [
                (method: .get, route: "/health", summary: "Getting health status", description: "Action for getting status of health"),
            ]
        )

        var document: OpenAPIDocument?
        do {
            document = try openAPIBuilder.build()
        } catch {
            print("Error...")
        }

        return document
    }


}
