//
//  TasksController.swift
//  TaskerServerPackageDescription
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD
import PerfectHTTP
import Swiftgger

class TasksController: Controller {

    private let tasksService: TasksServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.tasksService = tasksService
        self.authorizationService = authorizationService
    }

    override func initRoutes() {

        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])

        self.register(
            Action(method: .get, 
                   uri: "/tasks", 
                   summary: "All tasks", 
                   description: "Action for getting all tasks from server", 
                   responses: [
                        APIResponse(code: "200", description: "List of users", object: [taskDto]),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: all
            )
        )

        self.register(
            Action(method: .get, 
                   uri: "/tasks/{id}", 
                   summary: "Task by id", 
                   description: "Action for getting specific task from server", 
                   parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                   ],
                   responses: [
                        APIResponse(code: "200", description: "Specific task", object: taskDto),
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: get
            )
        )

        self.register(
            Action(method: .post, 
                   uri: "/tasks", 
                   summary: "New task", 
                   description: "Action for adding new task to the server", 
                   request: APIRequest(object: taskDto, description: "Object with task information."),
                   responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during adding new task", object: validationErrorResponseDto),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: post
            )
        )

        self.register(
            Action(method: .put, 
                   uri: "/tasks/{id}", 
                   summary: "Update task", 
                   description: "Action for updating specific task in the server",
                   parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                   ],
                   request: APIRequest(object: taskDto, description: "Object with task information."),
                   responses: [
                        APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
                        APIResponse(code: "400", description: "There was issues during updating task", object: validationErrorResponseDto),
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: put
            )
        )

        self.register(
            Action(method: .delete, 
                   uri: "/tasks/{id}", 
                   summary: "Delete task", 
                   description: "Action for deleting task from the database", 
                   parameters: [
                        APIParameter(name: "id", description: "Task id", required: true)
                   ],
                   responses: [
                        APIResponse(code: "200", description: "Task was deleted"),
                        APIResponse(code: "404", description: "Task with entered id not exists"),
                        APIResponse(code: "401", description: "User not authorized")
                   ],
                   authorization: .signedIn, 
                   handler: delete
            )
        )
    }

    override func getDescription() -> String {
        return "Controller for managing tasks."
    }

    public func all(request: HTTPRequest, response: HTTPResponse) {
        do {
            let tasks = try self.tasksService.get()

            var tasksDtos: [TaskDto] = []
            for task in tasks {
                tasksDtos.append(TaskDto(task: task))
            }

            response.sendJson(tasksDtos)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func get(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let task = try self.tasksService.get(byId: id) else {
                return response.sendNotFoundError()
            }

            guard let user = request.getUserCredentials() else {
                return response.sendUnauthorizedError()
            }

            if try !self.authorizationService.authorize(user: user,
                                                        resource: task,
                                                        requirement: OperationAuthorizationRequirement(operation: .read)) {
                return response.sendForbiddenError()
            }

            let taskDto = TaskDto(task: task)
            return response.sendJson(taskDto)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func post(request: HTTPRequest, response: HTTPResponse) {
        do {
            let taskDto = try request.getObjectFromRequest(TaskDto.self)
            let task = taskDto.toTask()

            guard let user = request.getUserCredentials() else {
                return response.sendUnauthorizedError()
            }

            task.userId = user.id
            try self.tasksService.add(entity: task)

            let addedTaskDto = TaskDto(task: task)
            return response.sendJson(addedTaskDto)
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func put(request: HTTPRequest, response: HTTPResponse) {
        do {
            let taskDto = try request.getObjectFromRequest(TaskDto.self)

            guard let taskId = taskDto.id else {
                return response.sendNotFoundError()
            }

            guard let task = try self.tasksService.get(byId: taskId)  else {
                return response.sendNotFoundError()
            }

            task.isFinished = taskDto.isFinished
            task.name = taskDto.name

            try self.tasksService.update(entity: task)

            let updatedTaskDto = TaskDto(task: task)
            return response.sendJson(updatedTaskDto)
        } catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        } catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }

    public func delete(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard try self.tasksService.get(byId: id) != nil else {
                return response.sendNotFoundError()
            }

            try self.tasksService.delete(entityWithId: id)
            return response.sendOk()
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
