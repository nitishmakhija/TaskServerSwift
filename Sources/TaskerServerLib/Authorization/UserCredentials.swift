//
//  UserCredentials.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

public class UserCredentials {
    public let id: UUID
    public let name:String
    public let roles:[String]?
    
    init(id: UUID, name: String, roles: [String]?) {
        self.id = id
        self.name = name
        self.roles = roles
    }
}
