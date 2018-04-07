//
//  CreateUserAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class CreateUserAction: ActionProtocol {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .post
    }

    public func getUri() -> String {
        return "/users"
    }

    public func getMetadataSummary() -> String {
        return "New user"
    }

    public func getMetadataDescription() -> String {
        return "Action for adding new user to the server"
    }

    public func getMetadataRequest() -> APIRequest? {
        return APIRequest(object: UserDto.self, description: "Object with user information.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return  [
            APIResponse(code: "200", description: "User data after adding to the system", object: UserDto.self),
            APIResponse(code: "400", description: "There was issues during adding new user", object: ValidationErrorResponseDto.self),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .inRole(["Administrator"])
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
