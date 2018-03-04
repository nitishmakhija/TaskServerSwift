//
//  AuthorizationService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 03.03.2018.
//

import Foundation

public protocol AuthorizationServiceProtocol {
    func add(authorizationHandler: AuthorizationHandlerProtocol)
    func add(policy: String, requirements: [AuthorizationRequirementProtocol])
    
    func authorize(user: UserCredentials, resource: EntityProtocol, requirement: AuthorizationRequirementProtocol) throws -> Bool
    func authorize(user: UserCredentials, resource: EntityProtocol, policy: String) throws -> Bool
}

public class AuthorizationService : AuthorizationServiceProtocol {
    
    var authorizationHandlers: [AuthorizationHandlerProtocol] = []
    var authorizationPolicies: [String: [AuthorizationRequirementProtocol]] = [:]
    
    public func add(authorizationHandler: AuthorizationHandlerProtocol) {
        self.authorizationHandlers.append(authorizationHandler)
    }
    
    public func add(policy: String, requirements: [AuthorizationRequirementProtocol]) {
        self.authorizationPolicies[policy] = requirements
    }
    
    public func authorize(user: UserCredentials, resource: EntityProtocol, requirement: AuthorizationRequirementProtocol) throws -> Bool {
        
        for authorizationHandler in authorizationHandlers {
            if authorizationHandler.resourceType == type(of: resource) && authorizationHandler.requirementType == type(of: requirement) {
                let authorizationResult = try authorizationHandler.handle(user: user, resource: resource, requirement: requirement)
                if authorizationResult == false {
                    return false
                }
            }
        }
        
        return true
    }
    
    public func authorize(user: UserCredentials, resource: EntityProtocol, policy: String) throws -> Bool {
        
        if let requirements = authorizationPolicies[policy] {
            for requirement in requirements {
                let authorizationResult = try self.authorize(user: user, resource: resource, requirement: requirement)
                if authorizationResult == false {
                    return false
                }
            }
        }
        
        return true
    }
}
