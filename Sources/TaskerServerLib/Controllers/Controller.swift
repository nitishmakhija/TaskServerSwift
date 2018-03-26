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
    case signedIn
    case inRole([String])
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

        let route = Route(method: method, uri: uri, handler: { (request: HTTPRequest, response: HTTPResponse) -> Void in
            if self.isUserHasAccess(request: request, response: response, authorization: authorization) {
                handler(request, response)
            }
        })

        self.allRoutes.add(route)
        addToRoutesWithAutorization(authorization, route)
    }

    private func addToRoutesWithAutorization(_ authorization: AuthorizationPolicy, _ route: Route) {
        switch authorization {
        case AuthorizationPolicy.signedIn, AuthorizationPolicy.inRole(_):
            self.routesWithAuthorization.add(route)
        default:
            break
        }
    }

    private func isUserHasAccess(request: HTTPRequest, response: HTTPResponse, authorization: AuthorizationPolicy) -> Bool {

        switch authorization {
        case AuthorizationPolicy.signedIn:
            guard request.getUserCredentials() != nil else {
                response.sendUnauthorizedError()
                return false
            }
        case let AuthorizationPolicy.inRole(roles):
            guard let userCredentials = request.getUserCredentials() else {
                response.sendUnauthorizedError()
                return false
            }

            if roles.count > 0 {

                guard let userRoles = userCredentials.roles else {
                    response.sendForbiddenError()
                    return false
                }

                var isUserInRole = false
                for role in roles {
                    if userRoles.contains(role) {
                        isUserInRole = true
                        break
                    }
                }

                if !isUserInRole {
                    response.sendForbiddenError()
                    return false
                }
            }

        default:
            break
        }

        return true
    }
}
