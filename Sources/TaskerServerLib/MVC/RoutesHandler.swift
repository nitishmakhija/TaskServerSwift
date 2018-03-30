//
//  Routes.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP

public class RoutesHandler {

    public func registerHandlers(for controllers: [ControllerProtocol]) -> Routes {

        var routes = Routes()
        for controller in controllers {
            for action in controller.getActions() {
                let route = self.register(action: action)
                routes.add(route)
            }
        }

        return routes
    }

    public func register(action: ActionProtocol) -> Route {

        let route = Route(method: action.getHttpMethod(), uri: action.getUri(), handler: { (request: HTTPRequest, response: HTTPResponse) -> Void in
            if self.isUserHasAccess(request: request, response: response, authorization: action.getMetadataAuthorization()) {
                action.handler(request: request, response: response)
            }
        })

        return route
    }

    public func getWithAuthorization(for controllers: [ControllerProtocol]) -> Routes {
        var routes = Routes()
        for controller in controllers {
            for action in controller.getActions() {
                if action.getMetadataAuthorization() != AuthorizationPolicy.anonymous {
                    let route = Route(method: action.getHttpMethod(), uri: action.getUri(), handler: action.handler)
                    routes.add(route)
                }
            }
        }

        return routes
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
