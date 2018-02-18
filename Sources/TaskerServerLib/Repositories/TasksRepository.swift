//
//  TasksRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public protocol TasksRepositoryProtocol {
    func getTasks() -> [Task]
    func getTask(id: Int) -> Task?
    func addTask(task: Task)
    func updateTask(task: Task)
    func deleteTask(id: Int)
}

class TasksRepository : TasksRepositoryProtocol {
    
    var tasks = [
        1: Task(id: 1, name: "Create new Perfect server", isFinished: false),
        2: Task(id: 2, name: "Improve MVC pattern on server side", isFinished: false),
        3: Task(id: 3, name: "Finish code refactoring", isFinished: false),
        4: Task(id: 4, name: "Move to newest fremeworks", isFinished: false)
    ]
    
    init(configuration: Configuration) {
        print("Database host: \(configuration.databaseHost)")
    }
    
    func getTasks() -> [Task] {
        return Array(self.tasks.values)
    }
    
    func getTask(id: Int) -> Task? {
        let filteredTasks = tasks.values.filter { (task) -> Bool in
            return task.id == id
        }
        
        return filteredTasks.first
    }
    
    func addTask(task: Task) {
        self.tasks[task.id] = task
    }
    
    func updateTask(task: Task) {
        self.tasks[task.id] = task
    }
    
    func deleteTask(id: Int) {
        self.tasks.removeValue(forKey: id)
    }
}
