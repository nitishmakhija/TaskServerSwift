//
//  TestServerContext.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
@testable import TaskerServerLib

class TestServerContext : ServerContext {
    
    private var _tasksController: TasksController!
    private var _usersController: UsersController!
    private var _healthController: HealthController!
    
    var tasksController: TasksController {
        get {
            if self._tasksController == nil {
                self._tasksController = try! self.container.resolve() as TasksController
            }
            
            return self._tasksController
        }
    }

    var usersController: UsersController {
        get {
            if self._usersController == nil {
                self._usersController = try! self.container.resolve() as UsersController
            }
            
            return self._usersController
        }
    }
    
    var healthController: HealthController {
        get {
            if self._healthController == nil {
                self._healthController = try! self.container.resolve() as HealthController
            }
            
            return self._healthController
        }
    }
    
    public override func initDatabase() {
        self.databaseContext = try! container.resolve() as DatabaseContextProtocol
        try! self.databaseContext.executeMigrations(policy: .dropTable)
        
        try! TestUsers.seed(databaseContext: databaseContext as! DatabaseContext)
        try! TestTasks.seed(databaseContext: databaseContext as! DatabaseContext)
    }
    
}
