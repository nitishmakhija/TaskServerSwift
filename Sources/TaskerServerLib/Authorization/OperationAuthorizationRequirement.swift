//
//  OperationAuthorizationRequirement.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 04.03.2018.
//

import Foundation

public enum Operations {
    case create
    case read
    case update
    case delete
}

public class OperationAuthorizationRequirement: AuthorizationRequirementProtocol {
    public let operation: Operations

    init(operation: Operations) {
        self.operation = operation
    }
}
