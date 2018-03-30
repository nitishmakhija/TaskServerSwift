//
//  DeleteTaskAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class DeleteTaskAction: ActionProtocol {

    private let tasksService: TasksServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.tasksService = tasksService
        self.authorizationService = authorizationService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .delete
    }

    public func getUri() -> String {
        return "/tasks/{id}"
    }

    public func getMetadataSummary() -> String {
        return "Delete task"
    }

    public func getMetadataDescription() -> String {
        return "Action for deleting task from the database"
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
        return [
            APIResponse(code: "200", description: "Task was deleted"),
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
