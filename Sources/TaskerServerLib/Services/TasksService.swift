//
//  TasksService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol TasksServiceProtocol {
    func get() throws -> [Task]
    func get(byId id: UUID) throws -> Task?
    func add(entity: Task) throws
    func update(entity: Task) throws
    func delete(entityWithId id: UUID) throws
}

public class TasksService: TasksServiceProtocol {

    private let taskValidator: TaskValidatorProtocol
    private let tasksRepository: TasksRepositoryProtocol

    init(taskValidator: TaskValidatorProtocol, tasksRepository: TasksRepositoryProtocol) {
        self.taskValidator = taskValidator
        self.tasksRepository = tasksRepository
    }

    public func get() throws -> [Task] {
        return try self.tasksRepository.get()
    }

    public func get(byId id: UUID) throws -> Task? {
        return try self.tasksRepository.get(byId: id)
    }

    public func add(entity: Task) throws {

        if let errors = self.taskValidator.getValidationErrors(entity) {
            throw ValidationsError(errors: errors)
        }

        try self.tasksRepository.add(entity: entity)
    }

    public func update(entity: Task) throws {

        if let errors = self.taskValidator.getValidationErrors(entity) {
            throw ValidationsError(errors: errors)
        }

        try self.tasksRepository.update(entity: entity)
    }

    public func delete(entityWithId id: UUID) throws {
        try self.tasksRepository.delete(entityWithId: id)
    }
}
