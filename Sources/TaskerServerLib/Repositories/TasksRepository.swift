//
//  TasksRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol TasksRepositoryProtocol {
    func get() throws -> [Task]
    func get(byId entityId: UUID) throws -> Task?
    func add(entity: Task) throws
    func update(entity: Task) throws
    func delete(entityWithId: UUID) throws
}

class TasksRepository: BaseRepository<Task>, TasksRepositoryProtocol {
}
