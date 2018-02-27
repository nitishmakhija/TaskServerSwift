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
        self.add(method: .post, uri: "/account/signIn", authorization: .anonymous, handler: signIn)
    }
    
    public func register(request: HTTPRequest, response: HTTPResponse) {
        do {
            let user = try request.getObjectFromRequest(User.self)
            
         
            try self.usersService.add(entity: user)
            return response.sendJson(user)
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
            let user = try self.usersService.get(byEmail: signIn.email, andPassword: signIn.password)
            
            if user == nil {
                return response.sendNotFoundError()
            }
            
            let tokenDto = try self.prepareToken(user: user!)
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
    
    private func prepareToken(user: User) throws -> JwtTokenResponseDto {
        
        let payload = [
            ClaimsNames.name.rawValue           : user.email,
            ClaimsNames.roles.rawValue          : ["User", "Administrator"],
            ClaimsNames.issuer.rawValue         : "tasker-server",
            ClaimsNames.issuedAt.rawValue       : Date().timeIntervalSince1970,
            ClaimsNames.expiration.rawValue     : Date().addingTimeInterval(36000).timeIntervalSince1970
        ] as [String : Any]
        
        guard let jwt = JWTCreator(payload: payload) else {
            throw AuthenticationError.generateTokenError
        }
        
        let token = try jwt.sign(alg: .hs256, key: self.configuration.secret)
        
        let tokenDto = JwtTokenResponseDto(token: token)
        return tokenDto
    }
}
