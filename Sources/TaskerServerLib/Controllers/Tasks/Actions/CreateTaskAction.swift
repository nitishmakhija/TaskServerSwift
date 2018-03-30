//
//  CreateTaskAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class CreateTaskAction: ActionProtocol {

    private let tasksService: TasksServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.tasksService = tasksService
        self.authorizationService = authorizationService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .post
    }

    public func getUri() -> String {
        return "/tasks"
    }

    public func getMetadataSummary() -> String {
        return "New task"
    }

    public func getMetadataDescription() -> String {
        return "Action for adding new task to the server"
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
        return [
            APIResponse(code: "200", description: "Task data after adding to the system", object: taskDto),
            APIResponse(code: "400", description: "There was issues during adding new task", object: validationErrorResponseDto),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
