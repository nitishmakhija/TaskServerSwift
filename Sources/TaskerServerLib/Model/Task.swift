//
//  Task.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public class Task : EntityProtocol {
    
    public var id: UUID
    public var name: String
    public var isFinished: Bool
    
    init(id: UUID, name: String, isFinished: Bool) {
        self.id = id
        self.name = name
        self.isFinished = isFinished
    }
}
