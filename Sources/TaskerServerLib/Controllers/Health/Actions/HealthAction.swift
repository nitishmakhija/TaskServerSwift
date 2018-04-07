//
//  HealthAction.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 29.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class HealthAction: ActionProtocol {

    public func getHttpMethod() -> HTTPMethod {
        return .get
    }

    public func getUri() -> String {
        return "/health"
    }

    public func getMetadataSummary() -> String {
        return "Helth checking"
    }

    public func getMetadataDescription() -> String {
        return "Action for getting status of health"
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return [
            APIResponse(code: "200", description: "Information about health", object: HealthStatusDto.self)
        ]
    }

    public func handler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJson(HealthStatusDto(message: "I'm fine and running!"))
    }
}
