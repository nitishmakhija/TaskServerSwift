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
            
            var tasksDtos:[TaskDto] = []
            for task in tasks {
                tasksDtos.append(TaskDto(task: task))
            }
            
            response.sendJson(tasksDtos)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func getTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = Int(stringId) else {
                return response.sendBadRequestError()
            }
                
            guard let task = try self.tasksService.get(byId: id) else {
                return response.sendNotFoundError()
            }
            
            let taskDto = TaskDto(task: task)
            return response.sendJson(taskDto)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func postTask(request: HTTPRequest, response: HTTPResponse) {
        do {
            let taskDto = try request.getObjectFromRequest(TaskDto.self)
            let task = taskDto.toTask()
            
            try self.tasksService.add(entity: task)
            
            let addedTaskDto = TaskDto(task: task)
            return response.sendJson(addedTaskDto)
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
            let taskDto = try request.getObjectFromRequest(TaskDto.self)
            
            guard let task = try self.tasksService.get(byId: taskDto.id)  else {
                return response.sendNotFoundError()
            }
            
            task.isFinished = taskDto.isFinished
            task.name = taskDto.name
            
            try self.tasksService.update(entity: task)
            
            let updatedTaskDto = TaskDto(task: task)
            return response.sendJson(updatedTaskDto)
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
            guard let stringId = request.urlVariables["id"], let id = Int(stringId) else {
                return response.sendBadRequestError()
            }

            guard let _ = try self.tasksService.get(byId: id) else {
                return response.sendNotFoundError()
            }
            
            try self.tasksService.delete(entityWithId: id)
            return response.sendOk();
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
}
