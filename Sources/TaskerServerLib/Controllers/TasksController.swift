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
    
    private let tasksQueries: TasksQueriesProtocol!
    private let tasksCommands: TasksCommandsProtocol!
    
    init(tasksCommands: TasksCommandsProtocol, tasksQueries: TasksQueriesProtocol) {
        self.tasksCommands = tasksCommands
        self.tasksQueries = tasksQueries
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
            let tasks = try self.tasksQueries.get()
            response.sendJson(tasks)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func getTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let task = try self.tasksQueries.get(byId: id) {
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
            try self.tasksCommands.add(entity: task)
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
            try self.tasksCommands.update(entity: task)
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
                if let _ = try self.tasksQueries.get(byId: id) {
                    try self.tasksCommands.delete(entityWithId: id)
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
