//
//  SqlConnectionProtocol.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.02.2018.
//

import Foundation
import PerfectCRUD

public protocol SqlConnectionProtocol {
    func getDatabaseConfiguration() -> DatabaseConfigurationProtocol
    func isValidConnection() -> Bool
}
