//
//  BaseRepository.swift
//  TaskerServerApp
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation
import PerfectCRUD

public class BaseRepository<T: EntityProtocol> {
    
    internal let databaseContext: DatabaseContextProtocol
    
    init(databaseContext: DatabaseContextProtocol) {
        self.databaseContext = databaseContext
    }
    
    func get() throws -> [T] {
        let tasks = try self.databaseContext.set(T.self).select()
        return tasks.sorted { (entity1, entity2) -> Bool in
            return entity1.id < entity2.id
        }
    }
    
    func get(byId id: Int) throws -> T? {
        let task = try self.databaseContext.set(T.self).where(\T.id == id).first()
        return task
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
