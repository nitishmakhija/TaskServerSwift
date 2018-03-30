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

    public let allTasks: AllTasksAction
    public let taskByIdAction: TaskByIdAction
    public let createTaskAction: CreateTaskAction
    public let updateTaskAction: UpdateTaskAction
    public let deleteTaskAction: DeleteTaskAction

    init(tasksService: TasksServiceProtocol, authorizationService: AuthorizationServiceProtocol) {
        self.allTasks = AllTasksAction(tasksService: tasksService)
        self.taskByIdAction = TaskByIdAction(tasksService: tasksService, authorizationService: authorizationService)
        self.createTaskAction = CreateTaskAction(tasksService: tasksService, authorizationService: authorizationService)
        self.updateTaskAction = UpdateTaskAction(tasksService: tasksService, authorizationService: authorizationService)
        self.deleteTaskAction = DeleteTaskAction(tasksService: tasksService, authorizationService: authorizationService)
    }

    override func initRoutes() {
        self.register(self.allTasks)
        self.register(self.taskByIdAction)
        self.register(self.createTaskAction)
        self.register(self.updateTaskAction)
        self.register(self.deleteTaskAction)
    }

    override func getDescription() -> String {
        return "Controller for managing tasks."
    }
}
