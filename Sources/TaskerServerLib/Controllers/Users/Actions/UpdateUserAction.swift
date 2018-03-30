//
//  UpdateUserAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UpdateUserAction: ActionProtocol {

    private let usersService: UsersServiceProtocol!

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .put
    }

    public func getUri() -> String {
        return "/users/{id}"
    }

    public func getMetadataSummary() -> String {
        return "Update user"
    }

    public func getMetadataDescription() -> String {
        return "Action for updating specific user in the server"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return [
            APIParameter(name: "id", description: "User id", required: true)
        ]
    }

    public func getMetadataRequest() -> APIRequest? {
        let userDto = UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false)
        return APIRequest(object: userDto, description: "Object with user information.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let userDto = UserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "email@test.com", isLocked: false)
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])
        return  [
            APIResponse(code: "200", description: "User data after adding to the system", object: userDto),
            APIResponse(code: "400", description: "There was issues during updating user", object: validationErrorResponseDto),
            APIResponse(code: "404", description: "User with entered id not exists"),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .inRole(["Administrator"])
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
