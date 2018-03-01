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
    private let userRolesRepository: UserRolesRepositoryProtocol
    private let userValidator: UserValidatorProtocol
    
    init(userValidator: UserValidatorProtocol, usersRepository: UsersRepositoryProtocol, userRolesRepository: UserRolesRepositoryProtocol) {
        self.userValidator = userValidator
        self.usersRepository = usersRepository
        self.userRolesRepository = userRolesRepository
    }
    
    public func get() throws -> [User] {
        return try self.usersRepository.get()
    }
    
    public func get(byId id: UUID) throws -> User? {
        let user =  try self.usersRepository.get(byId: id)
        try self.assignUserRoles(forUser: user)
        return user
    }
    
    public func add(entity: User) throws {
        
        entity.salt = String(randomWithLength: 14)
        entity.password = try entity.password.generateHash(salt: entity.salt)
        
        if let errors = self.userValidator.getValidationErrors(entity) {
            throw ValidationsError(errors: errors)
        }
        
        try self.usersRepository.add(entity: entity)
        try self.userRolesRepository.set(roles: entity.roles, forUserId: entity.id)
    }
    
    public func update(entity: User) throws {
        
        if let errors = self.userValidator.getValidationErrors(entity) {
            throw ValidationsError(errors: errors)
        }
        
        try self.usersRepository.update(entity: entity)
        try self.userRolesRepository.set(roles: entity.roles, forUserId: entity.id)
    }
    
    public func delete(entityWithId id: UUID) throws {
        try self.usersRepository.delete(entityWithId: id)
    }
    
    public func get(byEmail email: String) throws -> User? {
        let user = try self.usersRepository.get(byEmail:email)
        try self.assignUserRoles(forUser: user)
        return user
    }

    private func assignUserRoles(forUser user: User?) throws {
        if user != nil {
            let userRoles = try self.userRolesRepository.get(forUserId: user!.id)
            user!.roles = userRoles
        }
    }
}
