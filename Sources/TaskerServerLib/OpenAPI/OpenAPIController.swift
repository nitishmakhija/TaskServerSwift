//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP

public class  OpenAPIBuilder {

    var info: OpenAPIInfo
    var paths: [String: OpenAPIPathItem] = [:]
    var tags: [OpenAPITag] = []

    init(title: String, version: String, description: String, termsOfService: String? = nil, name: String? = nil, email: String? = nil, url: URL? = nil) {

        let contact = OpenAPIContact(name: name, email: email, url: url)

        self.info = OpenAPIInfo(
            title: title,
            version: version,
            description: description,
            termsOfService: termsOfService,
            contact: contact
        )
    }

    func addController(name: String, description: String, externalDocs: OpenAPIExternalDocumentation? = nil,
                       withActions actions: [(method: OpenAPIHttpMethod, route: String, summary: String?, description: String?)]) -> OpenAPIBuilder {

        let tag = OpenAPITag(name: name, description: description, externalDocs: externalDocs)
        tags.append(tag)

        for action in actions {
            self.addAction(controllerName: name, method: action.method, route: action.route, summary: action.summary, description: action.description)
        }

        return self
    }

    private func addAction(controllerName: String, method: OpenAPIHttpMethod, route: String, summary: String? = nil, description: String? = nil) {

        let parameter = OpenAPIParameter(name: "id", parameterLocation: .query, description: "Id number of object", required: true)
        let mediaType = OpenAPIMediaType(schema: OpenAPISchema(ref: "#/components/schemas/UserDto"),
                                         examples: ["user": OpenAPIExample(value: UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false))])
        let requestBody = OpenAPIRequestBody(description: "Request body description", content: ["application/json": mediaType])

        let openAPIOperation = OpenAPIOperation(summary: summary, description: description, tags: [controllerName], parameters: [parameter], requestBody: requestBody, responses: nil)

        var pathItem = paths[route]
        if pathItem == nil {
            pathItem = OpenAPIPathItem(summary: "This is API path summary", description: "This is API descriprion")
            paths[route] = pathItem
        }

        pathItem?.addOperation(method: method, operation: openAPIOperation)
    }

    func build() throws -> OpenAPIDocument {

        // User.
        let userDto = UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false)
        let userTypeMirror: Mirror = Mirror(reflecting: userDto)
        let userSchema = OpenAPISchema(type: "object", required: ["id"], properties: self.getProperties(properties: userTypeMirror.children))
        let userObjectType = String(describing: userTypeMirror.subjectType)

        // Task.
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        let taskTypeMirror: Mirror = Mirror(reflecting: taskDto)
        let taskSchema = OpenAPISchema(type: "object", required: ["id"], properties: self.getProperties(properties: taskTypeMirror.children))
        let taskObjectType = String(describing: taskTypeMirror.subjectType)

        let components = OpenAPIComponents(schemas: [
            userObjectType: userSchema,
            taskObjectType: taskSchema
        ])
        
        return OpenAPIDocument(info: self.info, paths: paths, tags: nil, components: components)
    }

    private func getProperties(properties: Mirror.Children) -> [(name: String, type: OpenAPIObjectProperty)] {

        var array:  [(name: String, type: OpenAPIObjectProperty)] = []
        for property in properties {
            let someType = type(of: unwrap(property.value))
            array.append((name: property.label!, type: OpenAPIObjectProperty(type: String(describing: someType))))
        }

        return array
    }

    func unwrap<T>(_ any: T) -> Any
    {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return any
        }
        return first.value
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
            termsOfService: "http://example.com/terms/",
            name: "Marcin Czachurski",
            email: "marcincz@email.com",
            url: URL(string: "http://medium.com/@mczachurski")
        )
        .addController(name: "Users", description: "Controller where we can manage users", withActions: [
                (method: .get, route: "/users", summary: "Getting all users", description: "Action for getting all users from server"),
                (method: .get, route: "/users/{id}", summary: "Getting user by id", description: "Action for getting specific user from server"),
                (method: .post, route: "/users", summary: "Adding new user", description: "Action for adding new user to the server"),
                (method: .put, route: "/users/{id}", summary: "Updating user", description: "Action for updating specific user in the server"),
                (method: .delete, route: "/users/{id}", summary: "Deleting new user", description: "Action for deleting user from the database")
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
