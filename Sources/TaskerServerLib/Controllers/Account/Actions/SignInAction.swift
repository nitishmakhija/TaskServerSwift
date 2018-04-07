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

    init(configuration: Configuration, usersService: UsersServiceProtocol) {
        self.configuration = configuration
        self.usersService = usersService
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

            let tokenProvider = TokenProvider(issuer: self.configuration.issuer, secret: self.configuration.secret)
            let token = try tokenProvider.prepareToken(user: user)
            return response.sendJson(JwtTokenResponseDto(token: token))
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

}
