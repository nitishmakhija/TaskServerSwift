//
//  HTTPRequest.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer

enum RequestError: Error {
    case BodyIsEmpty
}

extension HTTPRequest {
    
    func getObjectFromRequest<T>(_ type: T.Type) throws -> T where T : Decodable {
        if let json = self.postBodyString {
            return try self.decode(type, json)
        }
        
        throw RequestError.BodyIsEmpty
    }
    
    func add(userCredentials: UserCredentials) {
        self.scratchPad["userCredentials"] = userCredentials
    }
    
    func getUserCredentials() -> UserCredentials? {
        return self.scratchPad["userCredentials"] as? UserCredentials
    }
    
    private func decode<T>(_ type: T.Type, _ json: String) throws -> T where T : Decodable {
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let task = try decoder.decode(type, from: jsonData)
        
        return task
    }
}
