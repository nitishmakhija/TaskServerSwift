//
//  UserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct UserDto : Codable {

    public var id: UUID?
    public var name: String
    public var email: String
    public var isLocked: Bool
    public var roles: [String]?
    
    init(id: UUID, name: String, email: String, isLocked: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isLocked = isLocked
    }

    init(id: UUID, name: String, email: String, isLocked: Bool, roles: [String]?) {
        self.init(id: id, name: name, email: email, isLocked: isLocked)
        self.roles = roles
    }
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.isLocked = user.isLocked

        if user.roles != nil {
            self.roles = []
            for role in user.roles! {
                self.roles!.append(role.name)
            }
        }

    }
    
    public func toUser() -> User {

        var roles: [Role]?
        if self.roles != nil {
            roles = []
            for role in self.roles! {
                roles!.append(Role(id: UUID(), name: role))
            }
        }

        return User(
            id: self.id != nil ? self.id! : UUID(), 
            name: self.name, 
            email: self.email, 
            password: "", 
            salt: "", 
            isLocked: self.isLocked,
            roles: roles
        )
    }
}
