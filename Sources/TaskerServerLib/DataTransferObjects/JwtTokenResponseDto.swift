//
//  JwtTokenResponseDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

struct JwtTokenResponseDto : Codable {
    let token: String
    init(token: String) {
        self.token = token
    }
}
