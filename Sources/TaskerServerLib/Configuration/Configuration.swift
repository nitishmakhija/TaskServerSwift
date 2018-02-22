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
    public var connectionString: String
    
    init(manager: ConfigurationManager) {
        self.serverName = manager["serverName"] as? String ?? ""
        self.serverPort = manager["serverPort"] as? Int ?? 0
        self.logFile = manager["logFile"] as? String ?? ""
        self.connectionString = manager["connectionString"] as? String ?? ""
    }
}
