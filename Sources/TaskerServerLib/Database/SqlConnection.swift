//
//  SQLiteConnection.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.02.2018.
//

import Foundation
import PerfectCRUD
import PerfectSQLite
import FileKit

public protocol SqlConnectionProtocol {
    func getDatabaseConfiguration() -> DatabaseConfigurationProtocol
    func isValidConnection() -> Bool
}

class SQLiteConnection: SqlConnectionProtocol {

    private let connectionString: String
    private var configuration: SQLiteDatabaseConfiguration?
    private let lock = NSLock()

    public func getDatabaseConfiguration() -> DatabaseConfigurationProtocol {

        if self.configuration != nil && isValidConnection() {
            return self.configuration!
        }

        lock.lock()
        if self.configuration == nil {
            let databaseUrl = self.getDatabaseFileUrl()
            self.configuration = try! SQLiteDatabaseConfiguration(databaseUrl)
        }
        lock.unlock()

        return self.configuration!
    }

    init(configuration: Configuration) {
        self.connectionString = configuration.connectionString
    }

    public func isValidConnection() -> Bool {
        // Here we should verify state of connection.
        return true
    }

    private func getDatabaseFileUrl() -> String {
        let fn = NSString(string: self.connectionString)
        let pathUrl: URL
        let isAbsolutePath = fn.isAbsolutePath

        if isAbsolutePath {
            pathUrl = URL(fileURLWithPath: fn.expandingTildeInPath)
        } else {
            pathUrl = URL(fileURLWithPath: FileKit.workingDirectory)
                .appendingPathComponent(connectionString).standardized
        }

        return pathUrl.absoluteString
    }
}
