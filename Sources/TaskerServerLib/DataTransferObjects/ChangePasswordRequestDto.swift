//
//  ChangePasswordRequestDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

struct ChangePasswordRequestDto : Codable {
    var email: String = ""
    var password: String = ""
    
    init() {
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

