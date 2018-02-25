//
//  BaseCommands.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation
import PerfectCRUD

public class BaseCommands<T: EntityProtocol> {
    
    internal let databaseContext: DatabaseContextProtocol
    
    init(databaseContext: DatabaseContextProtocol) {
        self.databaseContext = databaseContext
    }
        
    func add(entity: T) throws {
        try self.databaseContext.set(T.self).insert(entity)
    }
    
    func update(entity: T) throws {
        try self.databaseContext.set(T.self).where(\T.id == entity.id).update(entity)
        
    }
    
    func delete(entityWithId id: Int) throws {
        try self.databaseContext.set(T.self).where(\T.id == id).delete()
    }
}
