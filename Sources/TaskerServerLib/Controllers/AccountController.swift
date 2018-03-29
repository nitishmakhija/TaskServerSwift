//
//  AccountController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class AccountController: Controller {

    private let usersService: UsersServiceProtocol
    private let configuration: Configuration

    init(configuration: Configuration, usersService: UsersServiceProtocol) {
        self.usersService = usersService
        self.configuration = configuration
    }

    override func initRoutes() {

        let changePasswordDto = ChangePasswordRequestDto(email: "email@test.pl", password: "123123")
        let registerUserDto = RegisterUserDto(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@email.com", isLocked: false, password: "sefg435")
        let signInDto = SignInDto(email: "john.doe@email.com", password: "234efsge")
        let jwtTokenResponseDto = JwtTokenResponseDto(token: "13r4qtfrq4t5egrf4qt5tgrfw45tgrafsdfgty54twgrthg")
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])

        self.register(
            Action(method: .post, 
                   uri: "/account/register", 
                   summary: "Registering new user", 
                   description: "Action for registering new user in system", 
                   request: APIRequest(object: registerUserDto, description: "Object with registration information."),
                   responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: registerUserDto),
                        APIResponse(code: "400", description: "User information are invalid", object: validationErrorResponseDto)
                   ],
                   authorization: .anonymous, 
                   handler: register
            )
        )

        self.register(
            Action(method: .post, 
                   uri: "/account/sign-in", 
                   summary: "Signinig in to the system", 
                   description: "Action for signing in user to the system", 
                   request: APIRequest(object: signInDto, description: "Object for signing in user."),
                   responses: [
                        APIResponse(code: "200", description: "Response with user token for authorization", object: jwtTokenResponseDto),
                        APIResponse(code: "404", description: "User credentials are invalid")
                   ],
                   authorization: .anonymous, 
                   handler: signIn
            )
        )

        self.register(
            Action(method: .post, 
                   uri: "/account/change-password", 
                   summary: "Changing password", 
                   description: "Action for changing password", 
                   request: APIRequest(object: changePasswordDto, description: "Object with new user password."),
                   responses: [
                        APIResponse(code: "200", description: "Password was changed"),
                        APIResponse(code: "400", description: "There was issues during changing password", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: changePassword
            )
        )
    }

    override func getDescription() -> String {
        return "Controller for managing user accout (registering/signing in/password)."
    }

    public func register(request: HTTPRequest, response: HTTPResponse) {
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

    public func signIn(request: HTTPRequest, response: HTTPResponse) {
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

    public func changePassword(request: HTTPRequest, response: HTTPResponse) {
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
