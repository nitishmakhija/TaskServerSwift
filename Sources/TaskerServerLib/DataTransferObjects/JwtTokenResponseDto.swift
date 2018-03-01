//
//  JwtTokenResponseDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

struct JwtTokenResponseDto : Codable {

    public var token: String

    init(token: String) {
        self.token = token
    }
}
