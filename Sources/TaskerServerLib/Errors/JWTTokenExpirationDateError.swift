//
//  JWTTokenExpirationDateError.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 01.03.2018.
//

import Foundation

enum JWTTokenExpirationDateError : Error {
    case tokenExpired
    case expiredDateNotExists
    case incorrectExpiredDate
}