//
//  UsersService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol UsersServiceProtocol {
    func get() throws -> [User]
    func get(byId id: UUID) throws -> User?
    func add(entity: User) throws
    func update(entity: User) throws
    func delete(entityWithId id: UUID) throws
    func get(byEmail email: String) throws -> User?
}

public class UsersService :  UsersServiceProtocol {
    
    private let usersRepository: UsersRepositoryProtocol
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func get() throws -> [User] {
        return try self.usersRepository.get()
    }
    
    public func get(byId id: UUID) throws -> User? {
        return try self.usersRepository.get(byId: id)
    }
    
    public func add(entity: User) throws {
        
        entity.salt = String(randomWithLength: 14)
        entity.password = try entity.password.generateHash(salt: entity.salt)
        
        if !entity.isValid() {
            let errors = entity.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try self.usersRepository.add(entity: entity)
    }
    
    public func update(entity: User) throws {
        
        if !entity.isValid() {
            let errors = entity.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try self.usersRepository.update(entity: entity)
    }
    
    public func delete(entityWithId id: UUID) throws {
        try self.usersRepository.delete(entityWithId: id)
    }
    
    public func get(byEmail email: String) throws -> User? {
        return try self.usersRepository.get(byEmail:email)
    }
}
