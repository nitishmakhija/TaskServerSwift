//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP

public class APIResponse {
    var object: Any?
    var description: String
    var code: String

    init(code: String, description: String, object: Any? = nil) {
        self.code = code
        self.description = description
        self.object = object
    }
}

public class APIAction {
    var method: OpenAPIHttpMethod
    var route: String
    var summary: String
    var description: String
    var parameters: [APIParameter]?
    var request: Any?
    var responses: [APIResponse]?
    var authorization: Bool = false

    init(
        method: OpenAPIHttpMethod,
        route: String,
        summary: String,
        description: String,
        parameters: [APIParameter]? = nil,
        request: Any? = nil,
        responses: [APIResponse]? = nil,
        authorization: Bool = false
    ) {
        self.method = method
        self.route = route
        self.summary = summary
        self.description = description
        self.parameters = parameters
        self.request = request
        self.responses = responses
        self.authorization = authorization
    }
}

public class APIParameter {
    var name: String
    var parameterLocation: OpenAPIParameterLocation = OpenAPIParameterLocation.path
    var description: String?
    var required: Bool = false
    var deprecated: Bool = false
    var allowEmptyValue: Bool = false

    init(
        name: String,
        parameterLocation: OpenAPIParameterLocation = OpenAPIParameterLocation.path,
        description: String? = nil,
        required: Bool = false,
        deprecated: Bool = false,
        allowEmptyValue: Bool = false
    ) {
        self.name = name
        self.parameterLocation = parameterLocation
        self.description = description
        self.required = required
        self.deprecated = deprecated
        self.allowEmptyValue = allowEmptyValue
    }
}

public enum APIAuthorizationType {
    case anonymous
    case basic
    case jwt
}

public class  OpenAPIBuilder {

    var info: OpenAPIInfo
    var paths: [String: OpenAPIPathItem] = [:]
    var tags: [OpenAPITag] = []
    var servers: [OpenAPIServer] = []
    var schemas: [String: OpenAPISchema] = [:]
    var authorizations: [APIAuthorizationType]?

    init(
        title: String,
        version: String,
        description: String,
        termsOfService: String? = nil,
        name: String? = nil,
        email: String? = nil,
        url: URL? = nil,
        authorizations: [APIAuthorizationType]?
    ) {

        let contact = OpenAPIContact(name: name, email: email, url: url)
        self.info = OpenAPIInfo(
            title: title,
            version: version,
            description: description,
            termsOfService: termsOfService,
            contact: contact
        )

        self.authorizations = authorizations
    }

    func addController(
        name: String,
        description: String,
        externalDocs: OpenAPIExternalDocumentation? = nil,
        withActions actions: [APIAction]
    ) -> OpenAPIBuilder {

        let tag = OpenAPITag(name: name, description: description, externalDocs: externalDocs)
        tags.append(tag)

        for action in actions {
            self.addAction(controllerName: name,
                           method: action.method,
                           route: action.route,
                           summary: action.summary,
                           description: action.description,
                           parameters: action.parameters,
                           request: action.request,
                           responses: action.responses,
                           authorization: action.authorization
            )
        }

        return self
    }

    func addServer(
        url: String,
        description: String? = nil,
        variables: [String: OpenAPIServerVariable]? = nil
    ) -> OpenAPIBuilder {
        let server = OpenAPIServer(url: url, description: description, variables: variables)
        self.servers.append(server)

        return self
    }

    private func addAction(
        controllerName: String,
        method: OpenAPIHttpMethod,
        route: String,
        summary: String? = nil,
        description: String? = nil,
        parameters: [APIParameter]? = nil,
        request: Any? = nil,
        responses: [APIResponse]? = nil,
        authorization: Bool = false
    ) {

        var apiParameters: [OpenAPIParameter]? = nil
        if parameters != nil {
            apiParameters = []

            for parameter in parameters! {
                let apiParameter = OpenAPIParameter(
                    name: parameter.name,
                    parameterLocation: parameter.parameterLocation,
                    description: parameter.description,
                    required: parameter.required,
                    deprecated: parameter.deprecated,
                    allowEmptyValue: parameter.allowEmptyValue
                )

                apiParameters!.append(apiParameter)
            }
        }

        var requestBody: OpenAPIRequestBody?
        if request != nil {
            let requestMirror: Mirror = Mirror(reflecting: request!)
            let mirrorObjectType = String(describing: requestMirror.subjectType)
            let objectTypeReference = "#/components/schemas/\(mirrorObjectType)"

            if self.schemas[mirrorObjectType] == nil {
                let requestSchema = OpenAPISchema(type: "object", required: ["id"], properties: self.getProperties(properties: requestMirror.children))
                self.schemas[mirrorObjectType] = requestSchema
            }

            let mediaType = OpenAPIMediaType(schema: OpenAPISchema(ref: objectTypeReference))
            requestBody = OpenAPIRequestBody(description: "Request body description", content: ["application/json": mediaType])
        }

        var openAPIResponses: [String: OpenAPIResponse] = [:]
        if responses != nil {
            for response in responses! {

                var objectTypeReference: String? = nil
                var isArray: Bool = false
                if response.object != nil {

                    var responseObject = response.object

                    if response.object is Array<Any> {
                        isArray = true
                        let arrayObject = responseObject! as! Array<Any>
                        responseObject = arrayObject[0]
                    }

                    let responseMirror: Mirror = Mirror(reflecting: responseObject!)
                    let mirrorObjectType = String(describing: responseMirror.subjectType)
                    objectTypeReference = "#/components/schemas/\(mirrorObjectType)"

                    if self.schemas[mirrorObjectType] == nil {
                        let responseSchema = OpenAPISchema(type: "object", required: ["id"], properties: self.getProperties(properties: responseMirror.children))
                        self.schemas[mirrorObjectType] = responseSchema
                    }
                }

                if objectTypeReference != nil {

                    var openAPISchema: OpenAPISchema?
                    if isArray {
                        let objectInArraySchema = OpenAPISchema(ref: objectTypeReference!)
                        openAPISchema = OpenAPISchema(type: "array", items: objectInArraySchema)
                    }
                    else {
                        openAPISchema = OpenAPISchema(ref: objectTypeReference!)
                    }

                    let openAPIResponseSchema = OpenAPIMediaType(schema: openAPISchema)
                    let openAPIResponse = OpenAPIResponse(description: response.description, content: ["application/json": openAPIResponseSchema])
                    openAPIResponses[response.code] = openAPIResponse
                }
                else {
                    let openAPIResponse = OpenAPIResponse(description: response.description)
                    openAPIResponses[response.code] = openAPIResponse
                }
            }
        }

        var securitySchemas: [[String: [String]]]? = nil
        if authorization && self.authorizations != nil {
            securitySchemas = []

            for authorization in self.authorizations! {
                if authorization == .basic {
                    var securityDict:[String: [String]] = [:]
                    securityDict["auth_basic"] = []
                    securitySchemas!.append(securityDict)
                } else if authorization == .jwt {
                    var securityDict:[String: [String]] = [:]
                    securityDict["auth_jwt"] = []
                    securitySchemas!.append(securityDict)
                }
            }
        }

        let openAPIOperation = OpenAPIOperation(
            summary: summary,
            description: description,
            tags: [controllerName],
            parameters: apiParameters,
            requestBody: requestBody,
            responses: openAPIResponses,
            security: securitySchemas
        )

        var pathItem = paths[route]
        if pathItem == nil {
            pathItem = OpenAPIPathItem()
            paths[route] = pathItem
        }

        pathItem!.addOperation(method: method, operation: openAPIOperation)
    }

    func build() throws -> OpenAPIDocument {

        var openAPISecuritySchema: [String: OpenAPISecurityScheme]? = nil
        if self.authorizations != nil {
            openAPISecuritySchema = [:]

            for authorization in self.authorizations! {
                if authorization == .basic {
                    openAPISecuritySchema!["auth_basic"] = OpenAPISecurityScheme(type: "http", description: "", name: "", parameterLocation: .header, scheme: "basic")
                } else if authorization == .jwt {
                    openAPISecuritySchema!["auth_jwt"] = OpenAPISecurityScheme(type: "http", description: "", name: "", parameterLocation: .header, scheme: "bearer", bearerFormat: "jwt")
                }
            }
        }

        let components = OpenAPIComponents(schemas: self.schemas, securitySchemes: openAPISecuritySchema)
        return OpenAPIDocument(info: self.info, paths: self.paths, servers: self.servers, tags: self.tags, components: components)
    }

    private func getProperties(properties: Mirror.Children) -> [(name: String, type: OpenAPIObjectProperty)] {

        var array:  [(name: String, type: OpenAPIObjectProperty)] = []
        for property in properties {
            let someType = type(of: unwrap(property.value))
            let typeName = String(describing: someType)
            let example = String(describing: unwrap(property.value))
            array.append((name: property.label!, type: OpenAPIObjectProperty(type: typeName.lowercased(), example: example)))
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

        let userDto = UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false)
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        let changePasswordDto = ChangePasswordRequestDto(email: "email@test.pl", password: "123123")
        let registerUserDto = RegisterUserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@email.com", isLocked: false, password: "sefg435")
        let signInDto = SignInDto(email: "john.doe@email.com", password: "234efsge")
        let jwtTokenResponseDto = JwtTokenResponseDto(token: "13r4qtfrq4t5egrf4qt5tgrfw45tgrafsdfgty54twgrthg")
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])
        let healthStatusDto = HealthStatusDto(message: "I'm fine and running!")

        let openAPIBuilder = OpenAPIBuilder(
            title: "Tasker server",
            version: "1.0.0",
            description: "This is a sample server for a pet store.",
            termsOfService: "http://example.com/terms/",
            name: "Marcin Czachurski",
            email: "marcincz@email.com",
            url: URL(string: "http://medium.com/@mczachurski"),
            authorizations: [.jwt]
        )
        .addController(name: "Account", description: "Controller where we can manage tasks", withActions: [
                APIAction(method: .post, route: "/account/register",
                    summary: "Register user",
                    description: "Action for registering new user in system",
                    request: registerUserDto,
                    responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: userDto),
                        APIResponse(code: "400", description: "User information are invalid", object: validationErrorResponseDto)
                    ]
                ),
                 APIAction(method: .post, route: "/account/sign-in",
                    summary: "Sign-in user",
                    description: "Action for signing in user to the system",
                    request: signInDto,
                    responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: jwtTokenResponseDto),
                        APIResponse(code: "404", description: "User credentials are invalid")
                    ]
                ),
                 APIAction(method: .post, route: "/account/change-password",
                    summary: "Change password",
                    description: "Action for changing password",
                    request: changePasswordDto,
                    responses: [
                        APIResponse(code: "200", description: "Password was changed"),
                        APIResponse(code: "400", description: "There was issues during changing password", object: validationErrorResponseDto)
                    ],
                    authorization: true
                )
            ]
        )
        .addController(name: "Users", description: "Controller where we can manage users", withActions: [
                APIAction(method: .get, route: "/users",
                    summary: "Getting all users",
                    description: "Action for getting all users from server",
                    responses: [
                        APIResponse(code: "200", description: "List of users", object: [userDto])
                    ],
                    authorization: true
                ),
                APIAction(method: .get, route: "/users/{id}",
                    summary: "Getting user by id",
                    description: "Action for getting specific user from server",
                    parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                    ],
                    responses: [
                        APIResponse(code: "200", description: "Specific user", object: userDto),
                        APIResponse(code: "404", description: "User with entered id not exists")
                    ],
                    authorization: true
                ),
                APIAction(method: .post, route: "/users",
                    summary: "Adding new user",
                    description: "Action for adding new user to the server",
                    request: userDto,
                    responses: [
                        APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
                        APIResponse(code: "400", description: "There was issues during adding new user", object: validationErrorResponseDto)
                    ],
                    authorization: true
                ),
                APIAction(method: .put, route: "/users/{id}",
                    summary: "Updating user",
                    description: "Action for updating specific user in the server",
                    parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                    ],
                    request: userDto,
                    responses: [
                        APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
                        APIResponse(code: "400", description: "There was issues during updating user", object: validationErrorResponseDto),
                        APIResponse(code: "404", description: "User with entered id not exists")
                    ],
                    authorization: true
                ),
                APIAction(method: .delete, route: "/users/{id}",
                    summary: "Deleting user",
                    description: "Action for deleting user from the database",
                    parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                    ],
                    responses: [
                        APIResponse(code: "200", description: "User was deleted"),
                        APIResponse(code: "404", description: "User with entered id not exists")
                    ],
                    authorization: true
                )
            ]
        )
        .addController(name: "Tasks", description: "Controller where we can manage tasks", withActions: [
                APIAction(method: .get, route: "/tasks",
                    summary: "Getting all tasks",
                    description: "Action for getting all tasks from server",
                    responses: [
                        APIResponse(code: "200", description: "List of users", object: [taskDto])
                    ],
                    authorization: true
                ),
                APIAction(method: .get, route: "/tasks/{id}",
                    summary: "Getting task by id",
                    description: "Action for getting specific task from server",
                    parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                    ],
                    responses: [
                        APIResponse(code: "200", description: "Specific task", object: taskDto),
                        APIResponse(code: "404", description: "Task with entered id not exists")
                    ],
                    authorization: true
                ),
                APIAction(method: .post, route: "/tasks",
                    summary: "Adding new task",
                    description: "Action for adding new task to the server",
                    request: taskDto,
                    responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during adding new task", object: validationErrorResponseDto)
                    ],
                    authorization: true
                ),
                APIAction(method: .put, route: "/tasks/{id}",
                    summary: "Updating task",
                    description: "Action for updating specific task in the server",
                    parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                    ],
                    request: taskDto,
                    responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during updating task", object: validationErrorResponseDto),
                        APIResponse(code: "404", description: "Task with entered id not exists")
                    ],
                    authorization: true
                ),
                APIAction(method: .delete, route: "/tasks/{id}",
                    summary: "Deleting task",
                    description: "Action for deleting task from the database",
                    parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                    ],
                    responses: [
                        APIResponse(code: "200", description: "Task was deleted"),
                        APIResponse(code: "404", description: "Task with entered id not exists")
                    ],
                    authorization: true
                )
            ]
        )
        .addController(name: "Health", description: "Controller where we can check health", withActions: [
                APIAction(method: .get, route: "/health",
                    summary: "Getting health status",
                    description: "Action for getting status of health",
                    request: nil,
                    responses: [
                        APIResponse(code: "200", description: "Information about health", object: healthStatusDto)
                    ]
                ),
            ]
        )
        .addServer(url: "http://localhost:8181", description: "Main server")
        .addServer(url: "http://localhost:{port}/{basePath}", description: "Secure server", variables:
            [
                "port": OpenAPIServerVariable(defaultValue: "80", enumValues: ["80", "443"], description: "Port to the API"),
                "basePath": OpenAPIServerVariable(defaultValue: "v1", description: "Base path to the server API")
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
