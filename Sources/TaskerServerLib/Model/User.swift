//
//  User.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public class User: EntityProtocol {

    public var id: UUID
    public var createDate: Date
    public var name: String
    public var email: String
    public var password: String
    public var salt: String
    public var isLocked: Bool
    public var roles: [Role]?

    init(id: UUID, createDate: Date, name: String, email: String, password: String, salt: String, isLocked: Bool) {
        self.id = id
        self.createDate = createDate
        self.name = name
        self.email = email
        self.password = password
        self.salt = salt
        self.isLocked = isLocked
    }

    convenience init(id: UUID, createDate: Date, name: String, email: String,
                     password: String, salt: String, isLocked: Bool, roles: [Role]?) {
        self.init(id: id, createDate: createDate, name: name, email: email,
                  password: password, salt: salt, isLocked: isLocked)

        self.roles = roles
    }

    func getRolesNames() -> [String] {
        var roles: [String] = []
        if let userRoles = self.roles {
            for role in userRoles {
                roles.append(role.name)
            }
        }

        return roles
    }
}
