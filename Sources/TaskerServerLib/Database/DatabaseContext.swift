//
//  DatabaseContext.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.02.2018.
//

import Foundation
import PerfectCRUD
import PerfectSQLite

public protocol DatabaseContextProtocol {
    func executeMigrations() throws
    func set<T: Codable>(_ type: T.Type) -> Table<T, Database<SQLiteDatabaseConfiguration>>
}

public class DatabaseContext: DatabaseContextProtocol {

    private var sqlConnection: SqlConnectionProtocol
    private var database: Database<SQLiteDatabaseConfiguration>
    private let lock = NSLock()
    
    public func set<T: Codable>(_ type: T.Type) -> Table<T, Database<SQLiteDatabaseConfiguration>> {
        self.validateConnection()
        return database.table(type)
    }
    
    init(sqlConnection: SqlConnectionProtocol) {
        self.sqlConnection = sqlConnection
        let databaseConfiguration = sqlConnection.getDatabaseConfiguration() as! SQLiteDatabaseConfiguration
        self.database = Database(configuration: databaseConfiguration)
    }
    
    private func validateConnection() {
        
        if self.sqlConnection.isValidConnection() {
            return
        }
        
        lock.lock()
        if !self.sqlConnection.isValidConnection() {
            let databaseConfiguration = sqlConnection.getDatabaseConfiguration() as! SQLiteDatabaseConfiguration
            self.database = Database(configuration: databaseConfiguration)
        }
        lock.unlock()
    }
    
    public func executeMigrations() throws {
        self.validateConnection()
        
        try self.database.create(Task.self, policy: .reconcileTable)
        try self.database.create(User.self, policy: .reconcileTable)
        try self.database.create(Role.self, policy: .reconcileTable)
        try self.database.create(UserRole.self, policy: .reconcileTable)
        
        try Roles.seed(databaseContext: self)
        try Users.seed(databaseContext: self)
    }
}
