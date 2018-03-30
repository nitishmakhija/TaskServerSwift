//
//  DeleteUserAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class DeleteUserAction: ActionProtocol {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .delete
    }

    public func getUri() -> String {
        return "/users/{id}"
    }

    public func getMetadataSummary() -> String {
        return "Delete user"
    }

    public func getMetadataDescription() -> String {
        return "Action for deleting user from the database"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return [
            APIParameter(name: "id", description: "User id", required: true)
        ]
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return [
            APIResponse(code: "200", description: "User was deleted"),
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
