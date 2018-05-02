//
//  TaskDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

extension TaskDto {

    init(id: UUID, createDate: Date, name: String, isFinished: Bool) {
        self.id = id.uuidString
        self.createDate = DateHelper.toISO8601String(createDate)
        self.name = name
        self.isFinished = isFinished
    }

    init(task: Task) {
        self.id = task.id.uuidString
        self.createDate = DateHelper.toISO8601String(task.createDate)
        self.name = task.name
        self.isFinished = task.isFinished
    }

    public func toTask() -> Task {

        let guid = UUID(uuidString: self.id) ?? UUID.empty()
        let date = DateHelper.fromISO8601String(self.createDate) ?? Date()

        return Task(id: guid,
                    createDate: date,
                    name: self.name,
                    isFinished: self.isFinished,
                    userId: UUID.empty())
    }
}
