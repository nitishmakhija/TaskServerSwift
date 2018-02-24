//
//  UsersRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol UsersRepositoryProtocol {
    func get() throws -> [User]
    func get(byId id: Int) throws -> User?
    func add(entity: User) throws
    func update(entity: User) throws
    func delete(entityWithId: Int) throws
}

class UsersRepository : BaseRepository<User>, UsersRepositoryProtocol {
}
