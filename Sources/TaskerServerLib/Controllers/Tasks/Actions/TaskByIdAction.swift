//
//  GetByIdAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class TaskByIdAction: ActionProtocol {

    private let tasksService: TasksServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.tasksService = tasksService
        self.authorizationService = authorizationService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/tasks/{id}"
    }

    public func getMetadataSummary() -> String {
        return "Task by id"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting specific task from server"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return [
            APIParameter(name: "id", description: "Task id", required: true)
        ]
    }

    public func getMetadataRequest() -> APIRequest? {
        return nil
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        return [
            APIResponse(code: "200", description: "Specific task", object: taskDto),
            APIResponse(code: "404", description: "Task with entered id not exists"),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
