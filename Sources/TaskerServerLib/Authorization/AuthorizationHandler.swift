//
//  AuthorizationHandler.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 03.03.2018.
//

import Foundation

public protocol AuthorizationHandlerProtocol {
    
    var requirementType: AuthorizationRequirementProtocol.Type { get }
    var resourceType: EntityProtocol.Type { get }
    
    func handle(user: UserCredentials, resource: EntityProtocol, requirement: AuthorizationRequirementProtocol) throws -> Bool
}
