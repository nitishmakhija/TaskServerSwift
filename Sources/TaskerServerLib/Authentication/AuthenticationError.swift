//
//  AuthenticationError.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 27.02.2018.
//

import Foundation

enum AuthenticationError : Error {
    case generateTokenError, 
        generatePasswordError,
        verificationTokenError, 
        tokenExpiredError, 
        expiredDateNotExistsError, 
        incorrectExpiredDateError
}
