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
    func get(byEmail email: String, andPassword password: String) throws -> User?
}

class UsersRepository : BaseRepository<User>, UsersRepositoryProtocol {
    
    public func get(byEmail email: String, andPassword password: String) throws -> User? {
        let user = try self.databaseContext.set(User.self).where(\User.email == email && \User.password == password).first()
        return user
    }
}
