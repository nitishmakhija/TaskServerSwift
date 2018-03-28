//
//  DatabaseContext.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.02.2018.
//

import Foundation
import PerfectCRUD
import PerfectSQLite
import FileKit
import Dispatch

public protocol DatabaseContextProtocol {
    func executeMigrations(policy: TableCreatePolicy) throws
    func set<T: Codable>(_ type: T.Type) throws -> Table<T, Database<SQLiteDatabaseConfiguration>>
}

public class DatabaseContext: DatabaseContextProtocol {
    private let connectionString: String
    private var database: Database<SQLiteDatabaseConfiguration>!
    private var syncQueue = DispatchQueue(label: "databaseQueue")

    init(configuration: Configuration) {
        self.connectionString = configuration.connectionString
    }

    public func executeMigrations(policy: TableCreatePolicy) throws {
        try self.getDatabase().create(Task.self, policy: policy)
        try self.getDatabase().create(User.self, policy: policy)
        try self.getDatabase().create(Role.self, policy: policy)
        try self.getDatabase().create(UserRole.self, policy: policy)

        try Roles.seed(databaseContext: self)
        try Users.seed(databaseContext: self)
    }

    public func set<T>(_ type: T.Type) throws -> Table<T, Database<SQLiteDatabaseConfiguration>> where T: Decodable, T: Encodable {
        return try getDatabase().table(type)
    }

    private func getDatabase() throws -> Database<SQLiteDatabaseConfiguration> {

        if self.isValidConnection() {
            return self.database
        }

        try syncQueue.sync {
            if !self.isValidConnection() {
                let sqliteConfiguration = try SQLiteDatabaseConfiguration(databaseUrl)
                self.database = Database(configuration: sqliteConfiguration)
            }
        }

        return self.database
    }

    private func isValidConnection() -> Bool {
        // Here we should verify state of the connection.
        let connectionIsValid = true

        return self.database != nil && connectionIsValid
    }

    private lazy var databaseUrl: String  = {
        let fn = NSString(string: self.connectionString)
        let pathUrl: URL
        let isAbsolutePath = fn.isAbsolutePath

        if isAbsolutePath {
            pathUrl = URL(fileURLWithPath: fn.expandingTildeInPath)
        } else {
            pathUrl = URL(fileURLWithPath: FileKit.workingDirectory)
                .appendingPathComponent(connectionString).standardized
        }

        var absoluteString = pathUrl.absoluteString

        #if os(Linux)
            absoluteString.removeFirst(7)
        #endif

        return absoluteString
    }()
}
