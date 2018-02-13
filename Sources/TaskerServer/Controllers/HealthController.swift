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

    private func getHealth(request: HTTPRequest, response: HTTPResponse) {
        
        let scoreArray: [String:Any] = ["state": true, "responseTime": 230.45]
        let encoded = try! scoreArray.jsonEncodedString()
        
        response.setHeader(.contentType, value: "text/json")
        response.appendBody(string: encoded).completed()
    }
}
