//
//  ValidationsError.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

public class ValidationsError: Error {
    let errors: [String: String]

    init(errors: [String: String]) {
        self.errors = errors
    }
}
