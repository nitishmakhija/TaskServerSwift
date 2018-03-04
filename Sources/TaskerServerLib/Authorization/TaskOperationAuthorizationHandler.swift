//
//  TaskOwnerAuthorizationHandler.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 04.03.2018.
//

import Foundation

public class TaskOperationAuthorizationHandler : AuthorizationHandlerProtocol {
    
    public var requirementType: AuthorizationRequirementProtocol.Type   = OperationAuthorizationRequirement.self
    public var resourceType: EntityProtocol.Type                        = Task.self
    
    public func handle(user: UserCredentials, resource: EntityProtocol, requirement: AuthorizationRequirementProtocol) throws -> Bool {
        
        guard let task = resource as? Task else {
            throw AuthorizationTypeMismatchError()
        }
        
        if task.userId == user.id {
            return true
        }
        
        return false
    }
    
    public required init() {
    }
}
