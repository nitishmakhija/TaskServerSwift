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

    init(id: UUID, createDate: Date, name: String, email: String, password: String, salt: String, isLocked: Bool) {
        self.id = id
        self.createDate = createDate
        self.name = name
        self.email = email
        self.password = password
        self.salt = salt
        self.isLocked = isLocked
    }
}
