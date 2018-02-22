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
        self.registerConfiguration(container: self, configuration: configuration)
        self.registerDatabase(container: self)
        self.registerRepositories(container: self)
        self.registerControllers(container: self)
    }
    
    public func resolveAllControllers() -> [Controller] {
        let controllers:[Controller] = [
            try! self.resolve() as HealthController,
            try! self.resolve() as TasksController,
            try! self.resolve() as UsersController
        ]
        
        return controllers
    }
    
    private func registerDatabase(container: DependencyContainer) {
        container.register(.singleton) { SQLiteConnection(configuration: $0) as SqlConnectionProtocol }
        container.register { DatabaseContext(sqlConnection: $0) as DatabaseContextProtocol }
    }
    
    private func registerConfiguration(container: DependencyContainer, configuration: Configuration) {
        container.register(.singleton) { configuration }
    }
    
    private func registerRepositories(container: DependencyContainer) {
        container.register { TasksRepository(databaseContext: $0) as TasksRepositoryProtocol }
        container.register { UsersRepository(databaseContext: $0) as UsersRepositoryProtocol }
    }
    
    private func registerControllers(container: DependencyContainer) {
        container.register { TasksController(tasksRepository: $0) }
        container.register { UsersController(usersRepository: $0) }
        container.register { HealthController() }
    }
}

