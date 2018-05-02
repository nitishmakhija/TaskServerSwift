//
//  RegisterUserDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

extension RegisterUserDto {

    init(id: UUID, createDate: Date, name: String, email: String, isLocked: Bool, password: String) {
        self.id = id.uuidString
        self.createDate = DateHelper.toISO8601String(createDate)
        self.name = name
        self.email = email
        self.isLocked = isLocked
        self.password = password
    }

    public func toUser() -> User {

        let guid = UUID(uuidString: self.id) ?? UUID.empty()
        let date = DateHelper.fromISO8601String(self.createDate) ?? Date()

        return User(id: guid,
                    createDate: date,
                    name: self.name,
                    email: self.email,
                    password: self.password,
                    salt: "",
                    isLocked: self.isLocked
        )
    }
}
