//
//  Configuration.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 17.02.2018.
//

import Foundation
import Configuration

public class Configuration {
    public var serverName: String
    public var serverPort: Int
    public var logFile: String
    public var databaseHost: String
    public var datanaseName: String
    public var databaseUser: String
    public var databasePassword: String
    
    init(manager: ConfigurationManager) {
        self.serverName = manager["serverName"] as? String ?? ""
        self.serverPort = manager["serverPort"] as? Int ?? 0
        self.logFile = manager["logFile"] as? String ?? ""
        self.databaseHost = manager["databaseHost"] as? String ?? ""
        self.datanaseName = manager["datanaseName"] as? String ?? ""
        self.databaseUser = manager["databaseUser"] as? String ?? ""
        self.databasePassword = manager["databasePassword"] as? String ?? ""
    }
}
