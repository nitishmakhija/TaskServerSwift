//
//  ChangePasswordAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class ChangePasswordAction: ActionProtocol {

    let usersService: UsersServiceProtocol

    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .post
    }

    public func getUri() -> String {
        return "/account/change-password"
    }

    public func getMetadataSummary() -> String {
        return "Changing password"
    }

    public func getMetadataDescription() -> String {
        return "Action for changing password"
    }

    public func getMetadataRequest() -> APIRequest? {
        let changePasswordDto = ChangePasswordRequestDto(email: "email@test.pl", password: "123123")
        return APIRequest(object: changePasswordDto, description: "Object with new user password.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])
        return [
            APIResponse(code: "200", description: "Password was changed"),
            APIResponse(code: "400", description: "There was issues during changing password", object: validationErrorResponseDto),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        do {
            let changePasswordDto = try request.getObjectFromRequest(ChangePasswordRequestDto.self)

            guard let user = try self.usersService.get(byEmail: changePasswordDto.email) else {
                return response.sendNotFoundError()
            }

            user.salt = String(randomWithLength: 14)
            user.password = try changePasswordDto.password.generateHash(salt: user.salt)

            try self.usersService.update(entity: user)
            return response.sendOk()
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
