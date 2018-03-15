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

    public func get() throws -> [T] {
        let entities = try self.databaseContext.set(T.self).order(by: \.createDate).select()

        var list: [T] = []
        for entity in entities {
            list.append(entity)
        }

        return list
    }

    public func get(byId entityId: UUID) throws -> T? {
        let entity = try self.databaseContext.set(T.self).where(\T.id == entityId).first()
        return entity
    }

    public func add(entity: T) throws {
        entity.id = UUID()
        try self.databaseContext.set(T.self).insert(entity)
    }

    public func update(entity: T) throws {
        try self.databaseContext.set(T.self).where(\T.id == entity.id).update(entity)

    }

    public func delete(entityWithId entityId: UUID) throws {
        try self.databaseContext.set(T.self).where(\T.id == entityId).delete()
    }
}
