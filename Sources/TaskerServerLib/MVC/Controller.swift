//
//  Controller.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

public class Controller {

    var allRoutes = Routes()
    var routesWithAuthorization = Routes()
    var actions: [ActionProtocol] = []

    init() {
        initRoutes()
    }

    func initRoutes() {
    }

    func getDescription() -> String {
        return ""
    }

    func getName() -> String {
        let className = String(describing: self)
        return className
    }

    public func register(_ action: ActionProtocol) {

        self.actions.append(action)

        let route = Route(method: action.getHttpMethod(), uri: action.getUri(), handler: { (request: HTTPRequest, response: HTTPResponse) -> Void in
            if self.isUserHasAccess(request: request, response: response, authorization: action.getMetadataAuthorization()) {
                action.handler(request: request, response: response)
            }
        })

        self.allRoutes.add(route)
        self.addToRoutesWithAutorization(action.getMetadataAuthorization(), route)
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
