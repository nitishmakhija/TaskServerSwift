//
//  FakeAuthorizeService.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
import TaskerServerLib

class FakeAuthorizationService : AuthorizationServiceProtocol {
    func add(authorizationHandler: AuthorizationHandlerProtocol) {
    }
    
    func add(policy: String, requirements: [AuthorizationRequirementProtocol]) {
    }
    
    func authorize(user: UserCredentials, resource: EntityProtocol, requirement: AuthorizationRequirementProtocol) throws -> Bool {
        return true
    }
    
    func authorize(user: UserCredentials, resource: EntityProtocol, policy: String) throws -> Bool {
        return true
    }
}
