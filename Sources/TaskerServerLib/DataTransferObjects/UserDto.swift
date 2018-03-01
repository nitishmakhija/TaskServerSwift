//
//  UserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct UserDto : Codable {

    public var id: Int
    public var name: String
    public var email: String
    public var isLocked: Bool
    
    init(id: Int, name: String, email: String, isLocked: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isLocked = isLocked
    }
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.isLocked = user.isLocked
    }
    
    public func toUser() -> User {
        return User(id: self.id, name: self.name, email: self.email, password: "", salt: "", isLocked: self.isLocked)
    }
}
