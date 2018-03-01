//
//  TaskValidations.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

public protocol TaskValidatorProtocol {
    func getValidationErrors(_ task: Task) -> [String: String]?
}

public class TaskValidator : TaskValidatorProtocol {
    
    public func getValidationErrors(_ task: Task) -> [String: String]? {
        
        var errors: [String: String] = [:]
        
        if task.name.isEmpty {
            errors["name"] = "Field is required."
        }
        
        return errors.count > 0 ? errors : nil
    }
}
