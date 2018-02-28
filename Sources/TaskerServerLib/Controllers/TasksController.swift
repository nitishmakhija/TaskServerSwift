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
    
    private let tasksService: TasksServiceProtocol!
    
    init(tasksService: TasksServiceProtocol) {
        self.tasksService = tasksService
    }
    
    override func initRoutes() {
        self.add(method: .get, uri: "/tasks", authorization: .signedIn, handler: getTasks)
        self.add(method: .get, uri: "/tasks/{id}", authorization: .signedIn, handler: getTask)
        self.add(method: .post, uri: "/tasks", authorization: .signedIn, handler: postTask)
        self.add(method: .put, uri: "/tasks/{id}", authorization: .signedIn, handler: putTask)
        self.add(method: .delete, uri: "/tasks/{id}", authorization: .signedIn, handler: deleteTask)
    }
    
    public func getTasks(request: HTTPRequest, response: HTTPResponse) {        
        do {
            let tasks = try self.tasksService.get()
            response.sendJson(tasks)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func getTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let task = try self.tasksService.get(byId: id) {
                    return response.sendJson(task)
                }
                else {
                    return response.sendNotFoundError()
                }
            }
            
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func postTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksService.add(entity: task)
            return response.sendJson(task)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func putTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let task = try request.getObjectFromRequest(Task.self)
            try self.tasksService.update(entity: task)
            return response.sendJson(task)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func deleteTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let _ = try self.tasksService.get(byId: id) {
                    try self.tasksService.delete(entityWithId: id)
                    return response.sendOk();
                }
                else {
                    return response.sendNotFoundError()
                }
            }
            
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
}
