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
    public func configure(withConfiguration configuration: Configuration) throws {
        self.addConfiguration(toContainer: self, configuration: configuration)
        try self.addDatabase(toContainer: self)
        self.addRepositories(toContainer: self)
        self.addServices(toContainer: self)
        self.addControllers(toContainer: self)
        self.addValidators(toContainer: self)
    }

    public func resolveAllControllers() throws -> [Controller] {
        let controllers: [Controller] = [
            try self.resolve() as HealthController,
            try self.resolve() as TasksController,
            try self.resolve() as UsersController,
            try self.resolve() as AccountController
        ]

        return controllers
    }

    private func addDatabase(toContainer container: DependencyContainer) throws {
        container.register(.singleton) { SQLiteConnection(configuration: $0) as SqlConnectionProtocol }
        container.register { try DatabaseContext(sqlConnection: $0) as DatabaseContextProtocol }
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
        container.register(.singleton) { AuthorizationService() as AuthorizationServiceProtocol }
        container.register { TasksService(taskValidator: $0, tasksRepository: $1) as TasksServiceProtocol }
        container.register { UsersService(userValidator: $0, usersRepository: $1,
                                          userRolesRepository: $2) as UsersServiceProtocol }
    }

    private func addControllers(toContainer container: DependencyContainer) {
        container.register { TasksController(tasksService: $0, authorizationService: $1) }
        container.register { UsersController(usersService: $0) }
        container.register { AccountController(configuration: $0, usersService: $1) }
        container.register { HealthController() }
    }

    private func addValidators(toContainer container: DependencyContainer) {
        container.register { TaskValidator() as TaskValidatorProtocol }
        container.register { UserValidator(usersRepository: $0) as UserValidatorProtocol }
    }
}
