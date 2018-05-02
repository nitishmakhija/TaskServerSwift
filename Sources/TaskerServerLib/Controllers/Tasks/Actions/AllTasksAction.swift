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

    public func getMetadataResponses() -> [APIResponse]? {
        return[
            APIResponse(code: "200", description: "List of users", array: TaskDto.self),
            APIResponse(code: "401", description: "User not authorized")
        ]
    }

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .signedIn
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        do {
            let tasks = try self.tasksService.get()

            var tasksDtos = TasksDto()
            for task in tasks {
                tasksDtos.tasks.append(TaskDto(task: task))
            }

            try response.sendJson(tasksDtos)
        } catch {
            response.sendInternalServerError(error: error)
        }
    }
}
