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

class TasksController: ControllerProtocol {

    private let actions: [ActionProtocol]

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.actions = [
            AllTasksAction(tasksService: tasksService),
            TaskByIdAction(tasksService: tasksService, authorizationService: authorizationService),
            CreateTaskAction(tasksService: tasksService, authorizationService: authorizationService),
            UpdateTaskAction(tasksService: tasksService, authorizationService: authorizationService),
            DeleteTaskAction(tasksService: tasksService, authorizationService: authorizationService)
        ]
    }

    func getMetadataName() -> String {
        return "Tasks"
    }

    func getMetadataDescription() -> String {
        return "Controller for managing tasks."
    }

    func getActions() -> [ActionProtocol] {
        return self.actions
    }
}
