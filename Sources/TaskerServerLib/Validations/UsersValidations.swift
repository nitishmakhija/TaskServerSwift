//
//  UsersValidations.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

public extension User {
    
    public func isValid() -> Bool {
        return !self.name.isEmpty && !self.email.isEmpty && !self.password.isEmpty
    }
    
    public func getValidationErrors() -> [String: String] {
        
        var errors: [String: String] = [:]
        
        if self.name.isEmpty {
            errors["name"] = "Field is required."
        }
        
        if self.email.isEmpty {
            errors["email"] = "Field is required."
        }

        if self.password.isEmpty {
            errors["password"] = "Field is required."
        }
        
        return errors
    }
}
