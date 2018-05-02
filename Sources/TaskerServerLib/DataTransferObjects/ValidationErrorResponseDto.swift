//
//  ValidationErrorResponseDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

extension ValidationErrorResponseDto {

    init(message: String, errors: [String: String]) {
        self.message = message

        for item in errors {
            var error = ErrorDto()
            error.field = item.key
            error.messages.append(item.value)

            self.errors.append(error)
        }
    }
}
