//
//  Action.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class Action {
    let method: HTTPMethod
    let uri: String
    let summary: String
    let description: String
    let parameters: [APIParameter]?
    let request: APIRequest?
    let responses: [APIResponse]?
    let authorization: AuthorizationPolicy
    let handler: RequestHandler

    init(method: HTTPMethod, 
         uri: String, 
         summary: String, 
         description: String, 
         parameters: [APIParameter]? = nil, 
         request: APIRequest? = nil, 
         responses: [APIResponse]? = nil, 
         authorization: AuthorizationPolicy, 
         handler: @escaping RequestHandler
    ) {
        self.method = method
        self.uri = uri
        self.summary = summary
        self.description = description
        self.parameters = parameters
        self.request = request
        self.responses = responses
        self.authorization = authorization
        self.handler = handler
    }
}