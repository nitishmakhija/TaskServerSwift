//
//  TestServerContext.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 11.03.2018.
//

// swiftlint:disable force_try

import Foundation
@testable import TaskerServerLib

class TestServerContext: ServerContext {

    private override init() throws {
        try super.init()
    }

    public static var shared: TestServerContext = {
        return try! TestServerContext()
    }()

    lazy var tasksController: TasksController = {
        let tasksController = try! self.container.resolve() as TasksController
        return tasksController
    }()

    lazy var usersController: UsersController = {
        let usersController = try! self.container.resolve() as UsersController
        return usersController
    }()

    lazy var healthController: HealthController = {
        let healthController = try! self.container.resolve() as HealthController
        return healthController
    }()

    lazy var accountController: AccountController = {
        let accountController = try! self.container.resolve() as AccountController
        return accountController
    }()

    public override func initDatabase() {
        self.databaseContext = try! container.resolve() as DatabaseContextProtocol
        try! self.databaseContext.executeMigrations(policy: .dropTable)

        // swiftlint:disable force_cast
        try! TestUsers.seed(databaseContext: databaseContext as! DatabaseContext)
        try! TestTasks.seed(databaseContext: databaseContext as! DatabaseContext)
        // swiftlint:enable force_cast
    }

}
