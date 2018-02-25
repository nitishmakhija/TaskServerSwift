//
//  TaskValidations.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

public extension Task {
    
    public func isValid() -> Bool {
        return !self.name.isEmpty
    }
    
    public func getValidationErrors() -> [String: String] {
        
        var errors: [String: String] = [:]
        
        if self.name.isEmpty {
            errors["name"] = "Field is required."
        }
        
        return errors
    }
}
