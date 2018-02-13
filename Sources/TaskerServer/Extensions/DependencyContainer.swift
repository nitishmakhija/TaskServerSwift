//
//  DependencyContainer.swift
//  TaskerServerPackageDescription
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import Dip

extension DependencyContainer {
    func configure() {
        self.registerRepositories(container: self)
        self.registerControllers(container: self)
    }
    
    func resolveAllControllers() -> [Controller] {
        let controllers:[Controller] = [
            try! container.resolve() as HealthController,
            try! container.resolve() as TasksController,
            try! container.resolve() as UsersController
        ]
        
        return controllers
    }
    
    private func registerRepositories(container: DependencyContainer) {
        container.register { TasksRepository() as TasksRepositoryProtocol }
        container.register { UsersRepository() as UsersRepositoryProtocol }
    }
    
    private func registerControllers(container: DependencyContainer) {
        container.register { TasksController(tasksRepository: $0) }
        container.register { UsersController(usersRepository: $0) }
        container.register { HealthController() }
    }
}

