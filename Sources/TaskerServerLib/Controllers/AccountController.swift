//
//  AccountController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectCrypto

class AccountController : Controller {
    
    private let usersService: UsersServiceProtocol
    private let configuration: Configuration
    
    init(configuration: Configuration, usersService: UsersServiceProtocol) {
        self.usersService = usersService
        self.configuration = configuration
    }
    
    override func initRoutes() {
        self.add(method: .post, uri: "/account/register", authorization: .anonymous, handler: register)
        self.add(method: .post, uri: "/account/sign-in", authorization: .anonymous, handler: signIn)
        self.add(method: .post, uri: "/account/change-password", authorization: .signedIn, handler: changePassword)
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
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
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
            
            let tokenDto = try self.prepareToken(user: user)
            return response.sendJson(tokenDto)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
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
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    private func prepareToken(user: User) throws -> JwtTokenResponseDto {
                
        let payload = [
            ClaimsNames.uid.rawValue            : user.id.uuidString,
            ClaimsNames.name.rawValue           : user.email,
            ClaimsNames.roles.rawValue          : user.getRolesNames(),
            ClaimsNames.issuer.rawValue         : self.configuration.issuer,
            ClaimsNames.issuedAt.rawValue       : Date().timeIntervalSince1970,
            ClaimsNames.expiration.rawValue     : Date().addingTimeInterval(36000).timeIntervalSince1970
        ] as [String : Any]
        
        guard let jwt = JWTCreator(payload: payload) else {
            throw PrepareTokenError()
        }
        
        let token = try jwt.sign(alg: .hs256, key: self.configuration.secret)
        
        let tokenDto = JwtTokenResponseDto(token: token)
        return tokenDto
    }
}
