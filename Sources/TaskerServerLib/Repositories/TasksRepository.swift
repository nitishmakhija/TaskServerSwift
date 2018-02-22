//
//  TasksRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol TasksRepositoryProtocol {
    func getTasks() throws -> [Task]
    func getTask(id: Int) throws -> Task?
    func addTask(task: Task) throws
    func updateTask(task: Task) throws
    func deleteTask(id: Int) throws
}

class TasksRepository : TasksRepositoryProtocol {
    
    private let databaseContext: DatabaseContextProtocol
    
    init(databaseContext: DatabaseContextProtocol) {
        self.databaseContext = databaseContext
    }
    
    func getTasks() throws -> [Task] {
        let tasks = try self.databaseContext.set(Task.self).select()
        return tasks.sorted { (task1, task2) -> Bool in
            return task1.name < task2.name
        }
    }
    
    func getTask(id: Int) throws -> Task? {
        let task = try self.databaseContext.set(Task.self).where(\Task.id == id).first()
        return task
    }
    
    func addTask(task: Task) throws {
        try self.databaseContext.set(Task.self).insert(task)
    }
    
    func updateTask(task: Task) throws {
        try self.databaseContext.set(Task.self).where(\Task.id == task.id).update(task)
        
    }
    
    func deleteTask(id: Int) throws {
        try self.databaseContext.set(Task.self).where(\Task.id == id).delete()
    }
}
