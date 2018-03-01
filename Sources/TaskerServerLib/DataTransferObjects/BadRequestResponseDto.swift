//
//  BadRequestResponseDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

struct BadRequestResponseDto : Codable {

    public var message: String

    init(message: String) {
        self.message = message
    }
}
