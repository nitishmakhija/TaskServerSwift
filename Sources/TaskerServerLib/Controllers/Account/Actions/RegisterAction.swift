//
//  Register.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class RegisterAction: ActionProtocol {
    let usersService: UsersServiceProtocol

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .post
    }

    public func getUri() -> String {
        return "/account/register"
    }

    public func getMetadataSummary() -> String {
        return "Registering new user"
    }

    public func getMetadataDescription() -> String {
        return "Action for registering new user in system"
    }

    public func getMetadataRequest() -> APIRequest? {
        let registerUserDto = RegisterUserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@email.com", isLocked: false, password: "fds")
        return APIRequest(object: registerUserDto, description: "Object with registration information.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let registerUserDto = RegisterUserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@email.com", isLocked: false, password: "fds")
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])

        return [
            APIResponse(code: "200", description: "Response with user token for authorization", object: registerUserDto),
            APIResponse(code: "400", description: "User information are invalid", object: validationErrorResponseDto)
        ]
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        do {
            let registerUserDto = try request.getObjectFromRequest(RegisterUserDto.self)
            let user = registerUserDto.toUser()

            try self.usersService.add(entity: user)

            guard let registeredUser = try self.usersService.get(byId: user.id) else {
                return response.sendNotFoundError()
            }

            let registeredUserDto = UserDto(user: registeredUser)
            return response.sendJson(registeredUserDto)
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
