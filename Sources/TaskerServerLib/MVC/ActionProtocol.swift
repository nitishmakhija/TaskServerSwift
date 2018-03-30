//
//  Action.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public protocol ActionProtocol {

    func getHttpMethod() -> HTTPMethod
    func getUri() -> String
    func handler(request: HTTPRequest, response: HTTPResponse)

    func getMetadataSummary() -> String
    func getMetadataDescription() -> String
    func getMetadataAuthorization() -> AuthorizationPolicy

    func getMetadataParameters() -> [APIParameter]?
    func getMetadataRequest() -> APIRequest?
    func getMetadataResponses() -> [APIResponse]?
}

extension ActionProtocol {

    public func getMetadataAuthorization() -> AuthorizationPolicy {
        return .anonymous
    }

    public func getMetadataParameters() -> [APIParameter]? {
        return nil
    }

    public func getMetadataRequest() -> APIRequest? {
        return nil
    }

    public func getMetadataResponses() -> [APIResponse]? {
        return nil
    }
}
