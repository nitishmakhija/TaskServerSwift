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
import SwiftProtobuf

extension HTTPResponse {

    func sendJson<T>(_ value: T) throws where T: SwiftProtobuf.Message {

        if self.acceptBinary() {
            let data = try value.serializedData()
            self.setHeader(.contentType, value: "application/octet-stream")
            self.appendBody(bytes: [UInt8](data)).completed()
        } else {
            let json = try value.jsonString()
            self.setHeader(.contentType, value: "application/json")
            self.appendBody(string: json).completed()
        }
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

        do {
            let errorJosn = try badRequestResponse.jsonString()
            self.appendBody(string: errorJosn).completed()
        } catch {
            Log.error(message: "Error during sending bad request response.")
        }
    }

    func sendValidationsError(error: ValidationsError) {
        self.status = .badRequest
        let validationErrorResponse = ValidationErrorResponseDto(
            message: "Error during parsing your request. Verify that all parameters and json was correct.",
            errors: error.errors)

        do {
            let errorJosn = try validationErrorResponse.jsonString()
            self.appendBody(string: errorJosn).completed()
        } catch {
            Log.error(message: "Error during sending validation error response.")
        }
    }

    func sendInternalServerError(error: Error) {
        self.status = .internalServerError

        var internalServerError = InternalServerErrorDto()
        internalServerError.error = error.localizedDescription

        switch error {
        case let sqliteError as SQLiteCRUDError:
            internalServerError.message = sqliteError.description
        default:
            break
        }

        do {
            let errorJosn = try internalServerError.jsonString()
            self.appendBody(string: errorJosn).completed()
        } catch {
            Log.error(message: "Error during sending internal server error response.")
        }
    }

    private func acceptBinary() -> Bool {
        guard let header = self.request.header(HTTPRequestHeader.Name.accept) else {
            return false
        }

        return header.contains(string: "application/octet-stream")
    }
}
