//
//  HTTPRequest.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer
import SwiftProtobuf

enum RequestError: Error {
    case bodyIsEmpty
}

extension HTTPRequest {

    func getObjectFromRequest<T>(_ type: T.Type) throws -> T where T: SwiftProtobuf.Message {

        if self.isBinary() {
            if let dataArray = self.postBodyBytes {
                return try T(serializedData: Data(bytes: dataArray))
            }
        } else {
            if let json = self.postBodyString {
                return try T(jsonString: json)
            }
        }

        throw RequestError.bodyIsEmpty
    }

    func add(userCredentials: UserCredentials) {
        self.scratchPad["userCredentials"] = userCredentials
    }

    func getUserCredentials() -> UserCredentials? {
        return self.scratchPad["userCredentials"] as? UserCredentials
    }

    private func isBinary() -> Bool {
        let contentType = self.header(HTTPRequestHeader.Name.contentType)
        return contentType == "application/octet-stream"
    }
}
