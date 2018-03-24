//
//  CORSFilter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation
import PerfectHTTP
import PerfectCrypto

public class CORSFilter: HTTPRequestFilter {

    public init() {
    }

    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> Void) {

        response.addHeader(HTTPResponseHeader.Name.accessControlAllowMethods, value: "GET, POST, PUT, DELETE")
        response.addHeader(HTTPResponseHeader.Name.accessControlAllowOrigin, value: "*")
        response.addHeader(HTTPResponseHeader.Name.accessControlAllowHeaders, value: "Origin, X-Requested-With, Content-Type, Accept, Authorization")

        if request.method == .options {
            response.status = .ok
            return callback(.halt(request, response))
        }

        return callback(.continue(request, response))
    }
}
