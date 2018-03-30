//
//  HealthController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 11.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class HealthController: ControllerProtocol {

    private let actions = [HealthAction()]

    func getMetadataName() -> String {
        return "Health"
    }

    func getMetadataDescription() -> String {
        return "Controller which returns service health information."
    }

    func getActions() -> [ActionProtocol] {
        return self.actions
    }
}
