//
//  TaskDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct TaskDto : Codable {

    public var id: UUID?
    public var createDate: Date
    public var name: String
    public var isFinished: Bool
    
    init(id: UUID, createDate: Date, name: String, isFinished: Bool) {
        self.id = id
        self.createDate = createDate
        self.name = name
        self.isFinished = isFinished
    }
    
    init(task: Task) {
        self.id = task.id
        self.createDate = task.createDate
        self.name = task.name
        self.isFinished = task.isFinished
    }
    
    public func toTask() -> Task {
        return Task(id: self.id ?? UUID.empty(), createDate: self.createDate, name: self.name, isFinished: self.isFinished, userId: UUID.empty())
    }
}
