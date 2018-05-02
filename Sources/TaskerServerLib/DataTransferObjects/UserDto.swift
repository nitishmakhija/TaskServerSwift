//
//  UserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

extension UserDto {

    init(id: UUID, createDate: Date, name: String, email: String, isLocked: Bool) {
        self.id = id.uuidString
        self.createDate = DateHelper.toISO8601String(createDate)
        self.name = name
        self.email = email
        self.isLocked = isLocked
    }

    init(id: UUID, createDate: Date, name: String, email: String, isLocked: Bool, roles: [String]?) {
        self.init(id: id, createDate: createDate, name: name, email: email, isLocked: isLocked)

        if let unwrappedRoles = roles {
            self.roles = unwrappedRoles
        }
    }

    init(user: User) {
        self.id = user.id.uuidString
        self.createDate = DateHelper.toISO8601String(user.createDate)
        self.name = user.name
        self.email = user.email
        self.isLocked = user.isLocked
        self.roles = user.getRolesNames()
    }

    public func toUser() -> User {

        let guid = UUID(uuidString: self.id) ?? UUID.empty()
        let date = DateHelper.fromISO8601String(self.createDate) ?? Date()

        return User(
            id: guid,
            createDate: date,
            name: self.name,
            email: self.email,
            password: "",
            salt: "",
            isLocked: self.isLocked,
            roles: self.getRoles()
        )
    }

    public func getRoles() -> [Role]? {
        var roles: [Role] = []
        for role in self.roles {
            roles.append(Role(id: UUID.empty(), createDate: Date(), name: role))
        }

        return roles
    }
}
