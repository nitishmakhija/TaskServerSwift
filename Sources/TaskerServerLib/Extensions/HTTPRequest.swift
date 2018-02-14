//
//  HTTPRequest.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP

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
    
    private func decode<T>(_ type: T.Type, _ json: String) throws -> T where T : Decodable {
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let task = try decoder.decode(type, from: jsonData)
        
        return task
    }
}
