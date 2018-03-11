//
//  Users.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 10.03.2018.
//

import Foundation
import PerfectCRUD

class Users {
    public class func seed(databaseContext: DatabaseContext) throws {
        let administrator = try databaseContext.set(User.self).where(\User.email == "admin@taskserver.com").first()
        if administrator == nil {
            
            let salt = String(randomWithLength: 14)
            let password = try "p@ssw0rd".generateHash(salt: salt)
            
            let user = User(id: UUID(), name: "Administrator", email: "admin@taskserver.com", password: password, salt: salt, isLocked: false)
            try databaseContext.set(User.self).insert(user)
            
            let roleAdministrator = try databaseContext.set(Role.self).where(\Role.name == "Administrator").first()
            try databaseContext.set(UserRole.self).insert(UserRole(id: UUID(), userId: user.id, roleId: roleAdministrator!.id))
        }
    }
}

