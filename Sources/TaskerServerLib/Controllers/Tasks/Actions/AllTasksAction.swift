//
//  GetAllAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class AllTasksAction: ActionProtocol {

    private let tasksService: TasksServiceProtocol

    init(tasksService: TasksServiceProtocol) {
        self.tasksService = tasksService
    }

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/tasks"
    }

    public func getMetadataSummary() -> String {
        return "All tasks"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting all tasks from server"
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return nil
    }

    public func getMetadataRequest() -> APIRequest? {
        return nil
    }

    public func getMetadataResponses() -> [APIResponse]? {
        let taskDto = TaskDto(id: UUID(), createDate: Date(), name: "Net task", isFinished: true)
        return[
            APIResponse(code: "200", description: "List of users", object: [taskDto]),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
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
}
