//
//  TasksController.swift
//  TaskerServerPackageDescription
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

class TasksController : Controller {
    
    private let tasksRepository: TasksRepositoryProtocol!
    
    init(tasksRepository: TasksRepositoryProtocol) {
        self.tasksRepository = tasksRepository
    }
    
    override func initRoutes() {
        routes.add(method: .get, uri: "/tasks", handler: getTasks)
        routes.add(method: .get, uri: "/tasks/{id}", handler: getTask)
        routes.add(method: .post, uri: "/tasks", handler: postTask)
        routes.add(method: .put, uri: "/tasks/{id}", handler: putTask)
        routes.add(method: .delete, uri: "/tasks/{id}", handler: deleteTask)
    }
    
    public func getTasks(request: HTTPRequest, response: HTTPResponse) {
        do {
            let tasks = try self.tasksRepository.getTasks()
            response.sendJson(tasks)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func getTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let task = try self.tasksRepository.getTask(id: id) {
                    return response.sendJson(task)
                }
            }
            
            response.sendNotFound()
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func postTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksRepository.addTask(task: task)
            
            return response.sendJson(task)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func putTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksRepository.updateTask(task: task)
            
            return response.sendJson(task)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func deleteTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                try self.tasksRepository.deleteTask(id: id)
                return response.sendOk();
            }
            
            response.sendNotFound()
        }
        catch {
            response.sendBadRequest()
        }
    }
}
