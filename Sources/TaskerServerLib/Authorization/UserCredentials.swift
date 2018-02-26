//
//  UserCredentials.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

class UserCredentials {
    public let name:String
    public let roles:[String]?
    
    init(name: String, roles: [String]?) {
        self.name = name
        self.roles = roles
    }
}
