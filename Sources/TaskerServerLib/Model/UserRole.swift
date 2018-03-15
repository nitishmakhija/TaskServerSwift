//
//  UserRole.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

public class UserRole: EntityProtocol {

    public var id: UUID
    public var createDate: Date
    public var userId: UUID
    public var roleId: UUID

    init(id: UUID, createDate: Date, userId: UUID, roleId: UUID) {
        self.id = id
        self.createDate = createDate
        self.userId = userId
        self.roleId = roleId
    }
}
