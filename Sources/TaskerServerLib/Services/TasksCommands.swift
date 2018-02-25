//
//  TasksService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol TasksCommandsProtocol {
    func add(entity: Task) throws
    func update(entity: Task) throws
    func delete(entityWithId id: Int) throws
}

class TasksCommands : BaseCommands<Task>, TasksCommandsProtocol {
    
    public func add(task: Task) throws {
        
        if !task.isValid() {
            let errors = task.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try super.add(entity: task)
    }
    
    public func update(task: Task) throws {
        
        if !task.isValid() {
            let errors = task.getValidationErrors()
            throw ValidationsError(errors: errors)
        }
        
        try super.update(entity: task)
    }
}
