//
//  UsersService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol UsersServiceProtocol {
    func get() throws -> [User]
    func get(byId id: Int) throws -> User?
    func add(entity: User) throws
    func update(entity: User) throws
    func delete(entityWithId id: Int) throws
}

public class UsersService :  UsersServiceProtocol {
    
    private let usersRepository: UsersRepositoryProtocol
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func get() throws -> [User] {
        return try self.usersRepository.get()
    }
    
    public func get(byId id: Int) throws -> User? {
        return try self.usersRepository.get(byId: id)
    }
    
    public func add(entity: User) throws {
        
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
    
    public func delete(entityWithId id: Int) throws {
        try self.usersRepository.delete(entityWithId: id)
    }
}
