//
//  Controller.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

public enum AuthorizationPolicy {
    case anonymous
    case authorized
}

public class Controller {
    var allRoutes = Routes()
    var routesWithAuthorization = Routes()
    
    init() {
        initRoutes()
    }
    
    func initRoutes() {
    }
    
    public func add(method: HTTPMethod, uri: String, authorization: AuthorizationPolicy, handler: @escaping RequestHandler) {
        
        let route = Route(method: method, uri: uri, handler: handler)
        self.allRoutes.add(route)
        
        if authorization == .authorized {
            self.routesWithAuthorization.add(route)
        }
    }
}
