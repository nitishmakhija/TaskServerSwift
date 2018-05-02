//
//  ChangePasswordRequestDto.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 28.02.2018.
//

import Foundation

extension ChangePasswordRequestDto {
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
