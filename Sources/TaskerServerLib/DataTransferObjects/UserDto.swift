//
//  UserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct UserDto : Codable {

    public var id: UUID?
    public var createDate: Date
    public var name: String
    public var email: String
    public var isLocked: Bool
    public var roles: [String]?
    
    init(id: UUID, createDate: Date, name: String, email: String, isLocked: Bool) {
        self.id = id
        self.createDate = createDate
        self.name = name
        self.email = email
        self.isLocked = isLocked
    }

    init(id: UUID, createDate: Date, name: String, email: String, isLocked: Bool, roles: [String]?) {
        self.init(id: id, createDate: createDate, name: name, email: email, isLocked: isLocked)
        self.roles = roles
    }
    
    init(user: User) {
        self.id = user.id
        self.createDate = user.createDate
        self.name = user.name
        self.email = user.email
        self.isLocked = user.isLocked
        self.roles = user.getRolesNames()
    }
    
    public func toUser() -> User {
        return User(
            id: self.id ?? UUID.empty(),
            createDate: self.createDate,
            name: self.name, 
            email: self.email, 
            password: "", 
            salt: "", 
            isLocked: self.isLocked,
            roles: self.getRoles()
        )
    }
    
    public func getRoles() -> [Role]? {
        var roles: [Role]?
        if let userRoles = self.roles {
            roles = []
            for role in userRoles {
                roles!.append(Role(id: UUID.empty(), createDate: Date(), name: role))
            }
        }
        
        return roles
    }
}
