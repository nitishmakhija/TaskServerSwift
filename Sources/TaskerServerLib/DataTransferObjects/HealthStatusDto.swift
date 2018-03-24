//
//  HealthStatusDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

struct HealthStatusDto: Codable {

    public var message: String

    init(message: String) {
        self.message = message
    }
}
