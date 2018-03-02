//
//  RegisterUserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct RegisterUserDto : Codable {
    
    public var id: UUID?
    public var name: String
    public var email: String
    public var isLocked: Bool
    public var password: String
    
    init(id: UUID, name: String, email: String, isLocked: Bool, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.isLocked = isLocked
        self.password = password
    }
    
    public func toUser() -> User {
        return User(id: self.id != nil ? self.id! : UUID.empty(), name: self.name, email: self.email, password: self.password, salt: "", isLocked: self.isLocked)
    }
}