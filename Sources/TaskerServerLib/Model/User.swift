//
//  User.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public class User : EntityProtocol {
    
    public var id: Int
    public var name: String
    public var email: String
    public var password: String
    public var isLocked: Bool
    
    init(id: Int, name: String, email: String, password: String, isLocked: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.isLocked = isLocked
    }
}
