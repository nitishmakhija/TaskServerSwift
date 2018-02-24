//
//  TasksController.swift
//  TaskerServerPackageDescription
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD
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
            let tasks = try self.tasksRepository.get()
            response.sendJson(tasks)
        }
        catch {
            response.sendError(error: error)
        }
    }
    
    public func getTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let task = try self.tasksRepository.get(byId: id) {
                    return response.sendJson(task)
                }
                else {
                    return response.sendNotFound()
                }
            }
            
            response.sendBadRequest()
        }
        catch {
            response.sendError(error: error)
        }
    }
    
    public func postTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksRepository.add(entity: task)
            return response.sendJson(task)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequest()
        }
        catch {
            response.sendError(error: error)
        }
    }
    
    public func putTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksRepository.update(entity: task)
            return response.sendJson(task)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequest()
        }
        catch {
            response.sendError(error: error)
        }
    }
    
    public func deleteTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let _ = try self.tasksRepository.get(byId: id) {
                    try self.tasksRepository.delete(entityWithId: id)
                    return response.sendOk();
                }
                else {
                    return response.sendNotFound()
                }
            }
            
            response.sendBadRequest()
        }
        catch {
            response.sendError(error: error)
        }
    }
}
