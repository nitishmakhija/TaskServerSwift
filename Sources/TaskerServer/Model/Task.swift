//
//  Task.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

class Task : Codable {
    
    var id: Int
    var name: String
    var isFinished: Bool
    
    init(id: Int, name: String, isFinished: Bool) {
        self.id = id
        self.name = name
        self.isFinished = isFinished
    }
}
