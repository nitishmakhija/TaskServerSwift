//
//  HealthController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 11.02.2018.
//

import Foundation
import PerfectHTTP

class HealthController: Controller {

    override func initRoutes() {
        self.add(method: .get, uri: "/health", authorization: .anonymous, handler: get)
    }

    func get(request: HTTPRequest, response: HTTPResponse) {
        response.sendJson(HealthStatusDto(message: "I'm fine and running!"))
    }
}
