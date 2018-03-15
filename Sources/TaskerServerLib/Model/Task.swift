//
//  Task.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public class Task: EntityProtocol {

    public var id: UUID
    public var createDate: Date
    public var name: String
    public var isFinished: Bool
    public var userId: UUID

    init(id: UUID, createDate: Date, name: String, isFinished: Bool, userId: UUID) {
        self.id = id
        self.createDate = createDate
        self.name = name
        self.isFinished = isFinished
        self.userId = userId
    }
}
