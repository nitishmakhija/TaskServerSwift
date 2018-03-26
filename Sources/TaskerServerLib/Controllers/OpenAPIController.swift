//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class OpenAPIController: Controller {

    override func initRoutes() {
        self.add(method: .get, uri: "/openapi", authorization: .anonymous, handler: all)
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
            description: "This is a sample server for task server application. Authorization is done by `JWT` token. You can register in the system, then sign-in and use token from response for authorization.",
            termsOfService: "http://example.com/terms/",
            name: "Marcin Czachurski",
            email: "marcincz@email.com",
            url: URL(string: "http://medium.com/@mczachurski"),
            authorizations: [.jwt(description: "You can get token from *sign-in* action from *Account* controller.")]
        )
        .addController(APIController(name: "Account", description: "Controller where we can manage tasks", actions: [
                APIAction(method: .post, route: "/account/register",
                    summary: "Register user",
                    description: "Action for registering new user in system",
                    request: APIRequest(object: registerUserDto, description: "Object with registration information."),
                    responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: registerUserDto),
                        APIResponse(code: "400", description: "User information are invalid", object: validationErrorResponseDto)
                    ]
                ),
                 APIAction(method: .post, route: "/account/sign-in",
                    summary: "Sign-in user",
                    description: "Action for signing in user to the system",
                    request: APIRequest(object: signInDto, description: "Object for signing in user."),
                    responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: jwtTokenResponseDto),
                        APIResponse(code: "404", description: "User credentials are invalid")
                    ]
                ),
                 APIAction(method: .post, route: "/account/change-password",
                    summary: "Change password",
                    description: "Action for changing password",
                    request: APIRequest(object: changePasswordDto, description: "Object with new user password."),
                    responses: [
                        APIResponse(code: "200", description: "Password was changed"),
                        APIResponse(code: "400", description: "There was issues during changing password", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                )
            ])
        )
        .addController(APIController(name: "Users", description: "Controller where we can manage users", actions: [
                APIAction(method: .get, route: "/users",
                    summary: "Getting all users",
                    description: "Action for getting all users from server",
                    responses: [
                        APIResponse(code: "200", description: "List of users", object: [userDto]),
                        APIResponse(code: "401", description: "User not authorized")
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
                        APIResponse(code: "404", description: "User with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                ),
                APIAction(method: .post, route: "/users",
                    summary: "Adding new user",
                    description: "Action for adding new user to the server",
                    request: APIRequest(object: userDto, description: "Object with user information."),
                    responses: [
                        APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
                        APIResponse(code: "400", description: "There was issues during adding new user", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                ),
                APIAction(method: .put, route: "/users/{id}",
                    summary: "Updating user",
                    description: "Action for updating specific user in the server",
                    parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                    ],
                    request: APIRequest(object: userDto, description: "Object with user information."),
                    responses: [
                        APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
                        APIResponse(code: "400", description: "There was issues during updating user", object: validationErrorResponseDto),
                        APIResponse(code: "404", description: "User with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
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
                        APIResponse(code: "404", description: "User with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                )
            ])
        )
        .addController(APIController(name: "Tasks", description: "Controller where we can manage tasks", actions: [
                APIAction(method: .get, route: "/tasks",
                    summary: "Getting all tasks",
                    description: "Action for getting all tasks from server",
                    responses: [
                        APIResponse(code: "200", description: "List of users", object: [taskDto]),
                        APIResponse(code: "401", description: "User not authorized")
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
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                ),
                APIAction(method: .post, route: "/tasks",
                    summary: "Adding new task",
                    description: "Action for adding new task to the server",
                    request: APIRequest(object: taskDto, description: "Object with task information."),
                    responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during adding new task", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                ),
                APIAction(method: .put, route: "/tasks/{id}",
                    summary: "Updating task",
                    description: "Action for updating specific task in the server",
                    parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                    ],
                    request: APIRequest(object: taskDto, description: "Object with task information."),
                    responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during updating task", object: validationErrorResponseDto),
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
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
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                    ],
                    authorization: true
                )
            ])
        )
        .addController(APIController(name: "Health", description: "Controller where we can check health", actions: [
                APIAction(method: .get, route: "/health",
                    summary: "Getting health status",
                    description: "Action for getting status of health",
                    request: nil,
                    responses: [
                        APIResponse(code: "200", description: "Information about health", object: healthStatusDto)
                    ]
                )
            ])
        )
        .addServer(APIServer(url: "http://localhost:8181", description: "Main server"))
        .addServer(APIServer(url: "http://localhost:{port}/{basePath}", description: "Secure server", variables:
            [
                APIVariable(name: "port", defaultValue: "80", enumValues: ["80", "443"], description: "Port to the API"),
                APIVariable(name: "basePath", defaultValue: "v1", description: "Base path to the server API")
            ])
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
