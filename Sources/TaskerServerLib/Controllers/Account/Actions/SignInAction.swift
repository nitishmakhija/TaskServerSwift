//
//  SignInAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class SignInAction: ActionProtocol {

    let usersService: UsersServiceProtocol
    let configuration: Configuration
    let userRolesService: UserRolesServiceProtocol

    init(configuration: Configuration, usersService: UsersServiceProtocol, userRolesService: UserRolesServiceProtocol) {
        self.configuration = configuration
        self.usersService = usersService
        self.userRolesService = userRolesService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .post
    }

    public func getUri() -> String {
        return "/account/sign-in"
    }

    public func getMetadataSummary() -> String {
        return "Signinig in to the system"
    }

    public func getMetadataDescription() -> String {
        return "Action for signing in user to the system"
    }

    public func getMetadataRequest() -> APIRequest? {
        return APIRequest(object: SignInDto.self, description: "Object for signing in user.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return [
            APIResponse(code: "200", description: "Response with user token for authorization", object: JwtTokenResponseDto.self),
            APIResponse(code: "404", description: "User credentials are invalid")
        ]
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        do {
            let signIn = try request.getObjectFromRequest(SignInDto.self)

            guard let user = try self.usersService.get(byEmail: signIn.email) else {
                return response.sendNotFoundError()
            }

            let password = try signIn.password.generateHash(salt: user.salt)
            if password != user.password {
                return response.sendNotFoundError()
            }

            let roles = try self.userRolesService.get(forUserId: user.id)

            let tokenProvider = TokenProvider(issuer: self.configuration.issuer, secret: self.configuration.secret)
            let token = try tokenProvider.prepareToken(user: user, roles: roles)
            return try response.sendJson(JwtTokenResponseDto(token: token))
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

}
