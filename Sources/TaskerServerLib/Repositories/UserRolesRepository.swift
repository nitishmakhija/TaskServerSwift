//
//  UserRolesRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 01.03.2018.
//

import Foundation
import PerfectCRUD

public protocol UserRolesRepositoryProtocol {
    func get(forUserId id: UUID) throws -> [Role]
    func set(roles: [Role]?, forUserId userid: UUID) throws
}

class UserRolesRepository : BaseRepository<User>, UserRolesRepositoryProtocol {
    
    public func get(forUserId userId: UUID) throws -> [Role] {
        
        let userRolesQuery = try self.databaseContext.set(UserRole.self).where(\UserRole.userId == userId).select()

        var roleIds: [UUID] = []
        for userRole in userRolesQuery {
            roleIds.append(userRole.roleId)
        }

        var roles: [Role] = []

        if roleIds.count > 0 {
            let rolesQuery = try self.databaseContext.set(Role.self).where(\Role.id ~ roleIds).select()
            for role in rolesQuery {
                roles.append(role)
            }
        }

        return roles
    }

    public func set(roles: [Role]?, forUserId userId: UUID) throws {

        try self.databaseContext.set(UserRole.self).where(\UserRole.userId == userId).delete()

        guard roles != nil && roles!.count > 0 else {
            return
        }

        var roleNames: [String] = []
        for role in roles! {
            roleNames.append(role.name)
        }

        let rolesQuery = try self.databaseContext.set(Role.self).where(\Role.name ~ roleNames).select()
        for role in rolesQuery {
            try self.databaseContext.set(UserRole.self).insert(UserRole(id: UUID(), createDate: Date(), userId: userId, roleId: role.id))
        }
    }
}
