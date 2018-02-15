//
//  HealthController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 11.02.2018.
//

import Foundation
import PerfectHTTP

class HealthController : Controller {
        
    override func initRoutes() {
        routes.add(method: .get, uri: "/health", handler: getHealth)
    }

    func getHealth(request: HTTPRequest, response: HTTPResponse) {
        
        let scoreArray: [String:Any] = ["message": "I'm fine and running!"]
        let encoded = try! scoreArray.jsonEncodedString()
        
        response.setHeader(.contentType, value: "text/json")
        response.appendBody(string: encoded).completed()
    }
}
