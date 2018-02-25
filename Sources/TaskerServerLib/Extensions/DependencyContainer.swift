//
//  DependencyContainer.swift
//  TaskerServerPackageDescription
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import Dip
import PerfectSQLite

extension DependencyContainer {
    public func configure(withConfiguration configuration: Configuration) {
        self.addConfiguration(toContainer: self, configuration: configuration)
        self.addDatabase(toContainer: self)
        self.addQueries(toContainer: self)
        self.addCommands(toContainer: self)
        self.addControllers(toContainer: self)
    }
    
    public func resolveAllControllers() -> [Controller] {
        let controllers:[Controller] = [
            try! self.resolve() as HealthController,
            try! self.resolve() as TasksController,
            try! self.resolve() as UsersController
        ]
        
        return controllers
    }
    
    private func addDatabase(toContainer container: DependencyContainer) {
        container.register(.singleton) { SQLiteConnection(configuration: $0) as SqlConnectionProtocol }
        container.register { DatabaseContext(sqlConnection: $0) as DatabaseContextProtocol }
    }
    
    private func addConfiguration(toContainer container: DependencyContainer, configuration: Configuration) {
        container.register(.singleton) { configuration }
    }
    
    private func addQueries(toContainer container: DependencyContainer) {
        container.register { TasksQueries(databaseContext: $0) as TasksQueriesProtocol }
        container.register { UsersQueries(databaseContext: $0) as UsersQueriesProtocol }
    }
    
    private func addCommands(toContainer container: DependencyContainer) {
        container.register { TasksCommands(databaseContext: $0) as TasksCommandsProtocol }
        container.register { UsersCommands(databaseContext: $0) as UsersCommandsProtocol }
    }
    
    private func addControllers(toContainer container: DependencyContainer) {
        container.register { TasksController(tasksCommands: $0, tasksQueries: $1) }
        container.register { UsersController(usersCommands: $0, usersQueries: $1) }
        container.register { HealthController() }
    }
}

