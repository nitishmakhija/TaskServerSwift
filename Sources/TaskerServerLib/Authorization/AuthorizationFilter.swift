//
//  AuthorizationFilter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import JWT

public enum ClaimsNames : String {
    case name = "name", roles = "roles"
}

public class AuthorizationFilter: HTTPRequestFilter {
    
    private let secret: Data
    private let routesWithAuthorization: Routes
    
    public init(secret: String, routesWithAuthorization: Routes) {
        self.secret = secret.data(using: .utf8)!
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
            let claims: ClaimSet = try JWT.decode(header!, algorithm: .hs256(self.secret))
            
            if let name = claims[ClaimsNames.name.rawValue] as? String {
                request.add(userCredentials: UserCredentials(name: name, roles: claims[ClaimsNames.roles.rawValue] as? [String]))
            }
            
        } catch let error as InvalidToken {
            print("Not valid token: \(error)")
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
