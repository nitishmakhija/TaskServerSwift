//
//  UsersService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol UsersCommandsProtocol {
    func add(entity: User) throws
    func update(entity: User) throws
    func delete(entityWithId id: Int) throws
}

class UsersCommands : BaseCommands<User>, UsersCommandsProtocol {
}
