//
//  UsersController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UserByIdAction: ActionProtocol {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/users/{id}"
    }

    public func getMetadataSummary() -> String {
        return "User by id"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting specific user from server"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return [
            APIParameter(name: "id", description: "User id", required: true)
        ]
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return [
            APIResponse(code: "200", description: "Specific user", object: UserDto.self),
            APIResponse(code: "404", description: "User with entered id not exists"),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .inRole(["Administrator"])
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let user = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }

            let userDto = UserDto(user: user)
            return try response.sendJson(userDto)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
