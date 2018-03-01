//
//  UserRole.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

public class UserRole : EntityProtocol {
    
    public var id: UUID
    public var userId: UUID
    public var roleId: UUID
    
    init(id: UUID, userId: UUID, roleId: UUID) {
        self.id = id
        self.userId = userId
        self.roleId = roleId
    }
}
