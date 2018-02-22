//
//  SQLiteConnection.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.02.2018.
//

import Foundation
import PerfectCRUD
import PerfectSQLite

public protocol SqlConnectionProtocol {
    func getDatabaseConfiguration() -> DatabaseConfigurationProtocol
    func isValidConnection() -> Bool
}

class SQLiteConnection : SqlConnectionProtocol {

    
    private let connectionString: String
    private var configuration: SQLiteDatabaseConfiguration?
    private let lock = NSLock()
    
    public func getDatabaseConfiguration() -> DatabaseConfigurationProtocol {

        if self.configuration != nil && isValidConnection() {
            return self.configuration!
        }
        
        lock.lock()
        if self.configuration == nil {
            self.configuration = try! SQLiteDatabaseConfiguration(connectionString)
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
}

