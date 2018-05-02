//
//  SignInDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation

extension SignInDto {
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
