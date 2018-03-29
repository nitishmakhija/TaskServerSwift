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

    override func initRoutes() {

        let healthStatusDto = HealthStatusDto(message: "I'm fine and running!")

        self.register(
            Action(method: .get, 
                   uri: "/health", 
                   summary: "Helth checking", 
                   description: "Action for getting status of health", 
                   responses: [
                        APIResponse(code: "200", description: "Information about health", object: healthStatusDto)
                   ],
                   authorization: .anonymous, 
                   handler: get
            )
        )
    }

    override func getDescription() -> String {
        return "Controller which returns service health information."
    }

    func get(request: HTTPRequest, response: HTTPResponse) {
        response.sendJson(HealthStatusDto(message: "I'm fine and running!"))
    }
}
