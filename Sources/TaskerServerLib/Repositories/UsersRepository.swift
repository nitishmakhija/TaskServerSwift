//
//  UsersRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol UsersRepositoryProtocol {
    func getUsers() throws -> [User]
    func getUser(id: Int) throws -> User?
    func addUser(user: User) throws
    func updateUser(user: User) throws
    func deleteUser(id: Int) throws
}

class UsersRepository : UsersRepositoryProtocol {
    
    private let databaseContext: DatabaseContextProtocol
        
    init(databaseContext: DatabaseContextProtocol) {
        self.databaseContext = databaseContext
    }
    
    func getUsers() throws -> [User] {
        let users = try self.databaseContext.set(User.self).select()
        return users.sorted { (user1, user2) -> Bool in
            return user1.name < user2.name
        }
    }
    
    func getUser(id: Int) throws -> User? {
        let user = try self.databaseContext.set(User.self).where(\User.id == id).first()
        return user
    }
    
    func addUser(user: User) throws {
        try self.databaseContext.set(User.self).insert(user)
    }
    
    func updateUser(user: User) throws {
        try self.databaseContext.set(User.self).where(\User.id == user.id).update(user)
    }
    
    func deleteUser(id: Int) throws {
        try self.databaseContext.set(User.self).where(\User.id == id).delete()
    }
    
}
