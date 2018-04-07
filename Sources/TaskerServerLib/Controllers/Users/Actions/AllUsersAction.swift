//
//  AllUsersAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class AllUsersAction: ActionProtocol {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/users"
    }

    public func getMetadataSummary() -> String {
        return "All users"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting all users from server"
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return [
            APIResponse(code: "200", description: "List of users", array: UserDto.self),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
