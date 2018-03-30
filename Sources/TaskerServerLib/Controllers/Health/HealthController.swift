//
//  HealthController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 11.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class HealthController: Controller {

    public let healthAction: HealthAction

    override init() {
        self.healthAction = HealthAction()
    }

    override func initRoutes() {
        self.register(healthAction)
    }

    override func getDescription() -> String {
        return "Controller which returns service health information."
    }
}
