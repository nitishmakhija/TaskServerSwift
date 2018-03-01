//
//  SignInDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

struct SignInDto : Codable {

    public var email: String
    public var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

