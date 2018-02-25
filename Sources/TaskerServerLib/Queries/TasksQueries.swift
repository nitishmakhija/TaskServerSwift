//
//  TasksRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol TasksQueriesProtocol {
    func get() throws -> [Task]
    func get(byId id: Int) throws -> Task?
}

class TasksQueries : BaseQueries<Task>, TasksQueriesProtocol {
}
