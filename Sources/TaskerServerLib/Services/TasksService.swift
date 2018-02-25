//
//  TasksService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol TasksServiceProtocol {
    func get() throws -> [Task]
    func get(byId id: Int) throws -> Task?
    func add(entity: Task) throws
    func update(entity: Task) throws
    func delete(entityWithId id: Int) throws
}

public class TasksService : TasksServiceProtocol {

    private let tasksRepository: TasksRepositoryProtocol
    
    init(tasksRepository: TasksRepositoryProtocol) {
        self.tasksRepository = tasksRepository
    }

    public func get() throws -> [Task] {
        return try self.tasksRepository.get()
    }
    
    public func get(byId id: Int) throws -> Task? {
        return try self.tasksRepository.get(byId: id)
    }
    
    public func add(entity: Task) throws {
        
        if !entity.isValid() {
            let errors = entity.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try self.tasksRepository.add(entity: entity)
    }
    
    public func update(entity: Task) throws {
        
        if !entity.isValid() {
            let errors = entity.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try self.tasksRepository.update(entity: entity)
    }
    
    public func delete(entityWithId id: Int) throws {
        try self.tasksRepository.delete(entityWithId: id)
    }
}
