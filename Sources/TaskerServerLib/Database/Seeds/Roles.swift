//
//  Roles.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation
import PerfectCRUD

class Roles {
    public class func seed(databaseContext: DatabaseContext) throws {
        let roleAdministrator = try databaseContext.set(Role.self).where(\Role.name == "Administrator").first()
        if roleAdministrator == nil {
            try databaseContext.set(Role.self).insert(Role(id: UUID(), createDate: Date(), name: "Administrator"))
        }

        let roleUser = try databaseContext.set(Role.self).where(\Role.name == "User").first()
        if roleUser == nil {
            try databaseContext.set(Role.self).insert(Role(id: UUID(), createDate: Date(), name: "User"))
        }
    }
}
