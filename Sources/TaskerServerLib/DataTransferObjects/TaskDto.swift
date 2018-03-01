//
//  TaskDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct TaskDto : Codable {

    public var id: Int
    public var name: String
    public var isFinished: Bool
    
    init(id: Int, name: String, isFinished: Bool) {
        self.id = id
        self.name = name
        self.isFinished = isFinished
    }
    
    init(task: Task) {
        self.id = task.id
        self.name = task.name
        self.isFinished = task.isFinished
    }
    
    public func toTask() -> Task {
        return Task(id: self.id, name: self.name, isFinished: self.isFinished)
    }
}
