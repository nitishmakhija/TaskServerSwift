//
//  Controller.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

public protocol ControllerProtocol {
    func getActions() -> [ActionProtocol]
    func getMetadataDescription() -> String
    func getMetadataName() -> String
}
