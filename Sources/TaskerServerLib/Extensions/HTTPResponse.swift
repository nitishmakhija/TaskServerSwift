//
//  HTTPResponse.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectSQLite

struct BadRequestResponse : Codable {
    let message: String
    init(message: String) {
        self.message = message
    }
}

struct ValidationErrorResponse : Codable {
    let message: String
    let errors: [String: String]
    init(message: String, errors: [String: String]) {
        self.message = message
        self.errors = errors
    }
}

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
    
    func sendNotFoundError() {
        self.status = .notFound
        self.completed()
    }

    func sendBadRequestError() {
        self.status = .badRequest
        let badRequestResponse = BadRequestResponse(message: "Error during parsing your request. Verify that all parameters and json was correct.")
        let errorJosn = encode(badRequestResponse)
        self.appendBody(string: errorJosn).completed()
    }
    
    func sendValidationsError(error: ValidationsError) {
        self.status = .badRequest
        let validationErrorResponse = ValidationErrorResponse(message: "Error during parsing your request. Verify that all parameters and json was correct.", errors: error.errors)
        let errorJosn = encode(validationErrorResponse)
        self.appendBody(string: errorJosn).completed()
    }
    
    func sendInternalServerError(error: Error) {
        self.status = .internalServerError
        
        var errorDictionary: [String:String] = [:]
        errorDictionary["error"] = error.localizedDescription
        
        switch error {
        case let sqliteError as SQLiteCRUDError:
            errorDictionary["description"] = sqliteError.description
        default:
            break
        }
        
        let errorJosn = encode(errorDictionary)
        self.appendBody(string: errorJosn).completed()
    }
    
    private func encode<T>(_ value: T) -> String where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(value)
        let json = String(data: jsonData, encoding: .utf8)!
        
        return json
    }
    
}
