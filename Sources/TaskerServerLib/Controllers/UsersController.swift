//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UsersController: Controller {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    override func initRoutes() {

        let userDto = UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false)
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])

        self.register(
            Action(method: .get, 
                   uri: "/users", 
                   summary: "All users", 
                   description: "Action for getting all users from server", 
                   responses: [
                        APIResponse(code: "200", description: "List of users", object: [userDto]),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .inRole(["Administrator"]), 
                   handler: all
            )
        )

        self.register(
            Action(method: .get, 
                   uri: "/users/{id}", 
                   summary: "User by id", 
                   description: "Action for getting specific user from server", 
                   parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                   ],
                   responses: [
                        APIResponse(code: "200", description: "Specific user", object: userDto),
                        APIResponse(code: "404", description: "User with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .inRole(["Administrator"]), 
                   handler: get
            )
        )

        self.register(
            Action(method: .post, 
                   uri: "/users", 
                   summary: "New user", 
                   description: "Action for adding new user to the server", 
                   request: APIRequest(object: userDto, description: "Object with user information."),
                   responses: [
                        APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
                        APIResponse(code: "400", description: "There was issues during adding new user", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .inRole(["Administrator"]), 
                   handler: post
            )
        )

        self.register(
            Action(method: .put, 
                   uri: "/users/{id}", 
                   summary: "Update user", 
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
                   authorization: .inRole(["Administrator"]), 
                   handler: put
            )
        )

        self.register(
            Action(method: .delete, 
                   uri: "/users/{id}", 
                   summary: "Delete user", 
                   description: "Action for deleting user from the database", 
                   parameters: [
                        APIParameter(name: "id", description: "User id", required: true)
                   ],
                   responses: [
                        APIResponse(code: "200", description: "User was deleted"),
                        APIResponse(code: "404", description: "User with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .inRole(["Administrator"]), 
                   handler: delete
            )
        )
    }

    override func getDescription() -> String {
        return "Controller for managing users."
    }

    public func all(request: HTTPRequest, response: HTTPResponse) {
        do {
            let users = try self.usersService.get()

            var usersDtos: [UserDto] = []
            for user in users {
                usersDtos.append(UserDto(user: user))
            }

            response.sendJson(usersDtos)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func get(request: HTTPRequest, response: HTTPResponse) {

        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let user = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }

            let userDto = UserDto(user: user)
            return response.sendJson(userDto)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func post(request: HTTPRequest, response: HTTPResponse) {
        do {
            let createUserDto = try request.getObjectFromRequest(RegisterUserDto.self)
            let user = createUserDto.toUser()

            try self.usersService.add(entity: user)

            guard let addedUser = try self.usersService.get(byId: user.id) else {
                return response.sendNotFoundError()
            }

            let addedUserDto = UserDto(user: addedUser)
            return response.sendJson(addedUserDto)
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func put(request: HTTPRequest, response: HTTPResponse) {
        do {
            let userDto = try request.getObjectFromRequest(UserDto.self)

            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let user = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }

            user.name = userDto.name
            user.isLocked = userDto.isLocked
            user.roles = userDto.getRoles()

            try self.usersService.update(entity: user)

            guard let updatedUser = try self.usersService.get(byId: user.id) else {
                return response.sendNotFoundError()
            }

            let updatedUserDto = UserDto(user: updatedUser)
            return response.sendJson(updatedUserDto)
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func delete(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard try self.usersService.get(byId: id) != nil else {
                return response.sendNotFoundError()
            }

            try self.usersService.delete(entityWithId: id)
            return response.sendOk()
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
