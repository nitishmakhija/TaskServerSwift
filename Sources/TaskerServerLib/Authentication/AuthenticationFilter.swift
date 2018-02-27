//
//  AuthorizationFilter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectCrypto

public enum ClaimsNames : String {
    case name = "name", roles = "roles", issuer = "iss", issuedAt = "iat", expiration = "exp"
}

public class AuthenticationFilter: HTTPRequestFilter {
    
    private let secret: String
    private let routesWithAuthorization: Routes
    
    public init(secret: String, routesWithAuthorization: Routes) {
        self.secret = secret
        self.routesWithAuthorization = routesWithAuthorization
    }
    
    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        
        let handler = self.routesWithAuthorization.navigator.findHandler(uri: request.uri, webRequest: request)
        if handler == nil {
            return callback(.continue(request, response))
        }
        
        var header = request.header(.authorization)
        if header == nil {
            response.sendUnauthorizedError()
            return callback(.halt(request, response))
        }
        
        let hasBearerPrefix = header!.starts(with: "Bearer ")
        if !hasBearerPrefix {
            response.sendUnauthorizedError()
            return callback(.halt(request, response))
        }
        
        do {
            header!.removeFirst(7)
            
            guard let jwt = JWTVerifier(header!) else {
                throw AuthenticationError.verificationTokenError
            }
            
            try jwt.verify(algo: .hs256, key: HMACKey(secret))
            try jwt.verifyExpirationDate()

            if let name = jwt.payload[ClaimsNames.name.rawValue] as? String {
                request.add(userCredentials: UserCredentials(name: name, roles: jwt.payload[ClaimsNames.roles.rawValue] as? [String]))
            }
            
        } catch is AuthenticationError {
            print("Not valid token error.")
            response.sendUnauthorizedError()
            return callback(.halt(request, response))
        } catch {
            print("Failed to decode JWT: \(error)")
            response.sendUnauthorizedError()
            return callback(.halt(request, response))
        }
        
        callback(.continue(request, response))
    }
}
