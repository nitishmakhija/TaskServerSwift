//
//  File.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

public class Role : EntityProtocol {
    
    public var id: UUID
    public var createDate: Date
    public var name: String
    
    init(id: UUID, createDate: Date, name: String) {
        self.id = id
        self.createDate = createDate
        self.name = name
    }
}
