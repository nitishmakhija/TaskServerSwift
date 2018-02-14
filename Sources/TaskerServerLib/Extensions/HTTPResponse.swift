//
//  HTTPResponse.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP

extension HTTPResponse {
    
    func sendJson<T>(_ value: T) where T : Encodable {
        let json = self.encode(value)
        
        self.setHeader(.contentType, value: "text/json")
        self.appendBody(string: json).completed()
    }
    
    func sendOk() {
        self.status = .ok
        self.completed()
    }
    
    func sendNotFound() {
        self.status = .notFound
        self.completed()
    }

    func sendBadRequest() {
        self.status = .badRequest
        self.completed()
    }
    
    private func encode<T>(_ value: T) -> String where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(value)
        let json = String(data: jsonData, encoding: .utf8)!
        
        return json
    }
    
}
