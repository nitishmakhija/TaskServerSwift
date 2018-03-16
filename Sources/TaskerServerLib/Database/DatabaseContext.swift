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
    func executeMigrations(policy: TableCreatePolicy) throws
    func set<T: Codable>(_ type: T.Type) throws -> Table<T, Database<SQLiteDatabaseConfiguration>>
}

public class DatabaseContext: DatabaseContextProtocol {

    private var sqlConnection: SqlConnectionProtocol
    private var database: Database<SQLiteDatabaseConfiguration>
    private let lock = NSLock()

    public func set<T: Codable>(_ type: T.Type) throws -> Table<T, Database<SQLiteDatabaseConfiguration>> {
        try self.validateConnection()
        return database.table(type)
    }

    init(sqlConnection: SqlConnectionProtocol) throws {
        self.sqlConnection = sqlConnection
        guard let databaseConfiguration = try sqlConnection.getDatabaseConfiguration() as? SQLiteDatabaseConfiguration else {
            throw GeneratePasswordError()
        }

        self.database = Database(configuration: databaseConfiguration)
    }

    private func validateConnection() throws {

        if self.sqlConnection.isValidConnection() {
            return
        }

        lock.lock()
        if !self.sqlConnection.isValidConnection() {
            guard let databaseConfiguration = try sqlConnection.getDatabaseConfiguration() as? SQLiteDatabaseConfiguration else {
                throw GeneratePasswordError()
            }

            self.database = Database(configuration: databaseConfiguration)
        }
        lock.unlock()
    }

    public func executeMigrations(policy: TableCreatePolicy) throws {
        try self.validateConnection()

        try self.database.create(Task.self, policy: policy)
        try self.database.create(User.self, policy: policy)
        try self.database.create(Role.self, policy: policy)
        try self.database.create(UserRole.self, policy: policy)

        try Roles.seed(databaseContext: self)
        try Users.seed(databaseContext: self)
    }
}
