//
//  File.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

public class Role : EntityProtocol {
    
    public var id: Int
    public var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
