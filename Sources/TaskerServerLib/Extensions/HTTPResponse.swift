//
//  HTTPResponse.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectSQLite
import PerfectLib

extension HTTPResponse {

    func sendJson<T>(_ value: T) where T: Encodable {
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

    func sendForbiddenError() {
        self.status = .forbidden
        self.completed()
    }

    func sendUnauthorizedError() {
        self.addHeader(.wwwAuthenticate, value: "Bearer realm=\"TaskerServer\"")
        self.status = .unauthorized
        self.completed()
    }

    func sendBadRequestError() {
        self.status = .badRequest
        let badRequestResponse = BadRequestResponseDto(
            message: "Error during parsing your request. Verify that all parameters and json was correct.")
        let errorJosn = encode(badRequestResponse)
        self.appendBody(string: errorJosn).completed()
    }

    func sendValidationsError(error: ValidationsError) {
        self.status = .badRequest
        let validationErrorResponse = ValidationErrorResponseDto(
            message: "Error during parsing your request. Verify that all parameters and json was correct.",
            errors: error.errors)
        let errorJosn = encode(validationErrorResponse)
        self.appendBody(string: errorJosn).completed()
    }

    func sendInternalServerError(error: Error) {
        self.status = .internalServerError

        var errorDictionary: [String: String] = [:]
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

    private func encode<T>(_ value: T) -> String where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        var json = ""
        do {
            let jsonData = try encoder.encode(value)
            json = String(data: jsonData, encoding: .utf8)!
        } catch {
            Log.error(message: "Error during serializable object to JSON")
        }

        return json
    }

}
