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
        self.addRepositories(toContainer: self)
        self.addServices(toContainer: self)
        self.addControllers(toContainer: self)
    }
    
    public func resolveAllControllers() -> [Controller] {
        let controllers:[Controller] = [
            try! self.resolve() as HealthController,
            try! self.resolve() as TasksController,
            try! self.resolve() as UsersController,
            try! self.resolve() as AccountController
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
    
    private func addRepositories(toContainer container: DependencyContainer) {
        container.register { TasksRepository(databaseContext: $0) as TasksRepositoryProtocol }
        container.register { UsersRepository(databaseContext: $0) as UsersRepositoryProtocol }
        container.register { UserRolesRepository(databaseContext: $0) as UserRolesRepositoryProtocol }
    }
    
    private func addServices(toContainer container: DependencyContainer) {
        container.register { TasksService(tasksRepository: $0) as TasksServiceProtocol }
        container.register { UsersService(usersRepository: $0, userRolesRepository: $1) as UsersServiceProtocol }
    }
    
    private func addControllers(toContainer container: DependencyContainer) {
        container.register { TasksController(tasksService: $0) }
        container.register { UsersController(usersService: $0) }
        container.register { AccountController(configuration: $0, usersService: $1) }
        container.register { HealthController() }
    }
}

