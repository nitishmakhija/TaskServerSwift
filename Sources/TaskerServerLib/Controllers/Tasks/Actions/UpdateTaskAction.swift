//
//  UpdateTaskAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UpdateTaskAction: ActionProtocol {

    private let tasksService: TasksServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.tasksService = tasksService
        self.authorizationService = authorizationService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .put
    }

    public func getUri() -> String {
        return "/tasks/{id}"
    }

    public func getMetadataSummary() -> String {
        return "Update task"
    }

    public func getMetadataDescription() -> String {
        return "Action for updating specific task in the server"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return [
            APIParameter(name: "id", description: "Task id", required: true)
        ]
    }

    public func getMetadataRequest() -> APIRequest? {
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        return APIRequest(object: taskDto, description: "Object with task information.")
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        let validationErrorResponseDto = ValidationErrorResponseDto(message: "Object is invalid", errors: ["property": "Information about error."])
        return  [
            APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
            APIResponse(code: "400", description: "There was issues during updating task", object: validationErrorResponseDto),
            APIResponse(code: "404", description: "Task with entered id not exists"),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
