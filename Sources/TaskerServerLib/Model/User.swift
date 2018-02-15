//
//  User.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public class User : Codable {
    
    var id: Int
    var name: String
    var email: String
    var isLocked: Bool
    
    init(id: Int, name: String, email: String, isLocked: Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isLocked = isLocked
    }
}
