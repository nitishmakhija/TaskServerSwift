//
//  ValidationErrorResponseDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

struct ValidationErrorResponseDto: Codable {

    public var message: String
    public var errors: [String: String]

    init(message: String, errors: [String: String]) {
        self.message = message
        self.errors = errors
    }
}
