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
    
    private func getTasks(request: HTTPRequest, response: HTTPResponse) {
        let tasks = self.tasksRepository.getTasks()
        response.sendJson(tasks)
    }
    
    private func getTask(request: HTTPRequest, response: HTTPResponse) {
        
        if let stringId = request.urlVariables["id"], let id = Int(stringId) {
            if let task = self.tasksRepository.getTask(id: id) {
                return response.sendJson(task)
            }
        }
        
        response.sendNotFound()
    }
    
    private func postTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            self.tasksRepository.addTask(task: task)
            
            return response.sendJson(task)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    private func putTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            self.tasksRepository.updateTask(task: task)
            
            return response.sendJson(task)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    private func deleteTask(request: HTTPRequest, response: HTTPResponse) {
        if let stringId = request.urlVariables["id"], let id = Int(stringId) {
            self.tasksRepository.deleteTask(id: id)
            return response.sendOk();
        }
        
        response.sendNotFound()
    }
}
