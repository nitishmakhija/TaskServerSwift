//
//  UserRole.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

public class UserRole : EntityProtocol {
    
    public var id: Int
    public var userId: Int
    public var roleId: Int
    
    init(id: Int, userId: Int, roleId: Int) {
        self.id = id
        self.userId = userId
        self.roleId = roleId
    }
}
