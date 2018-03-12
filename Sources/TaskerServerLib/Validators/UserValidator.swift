//
//  UsersValidations.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation

public protocol UserValidatorProtocol {
    func getValidationErrors(_ user: User, isNewUser: Bool) -> [String: String]?
}

public class UserValidator : UserValidatorProtocol {
    
    private let usersRepository: UsersRepositoryProtocol
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    public func getValidationErrors(_ user: User, isNewUser: Bool) -> [String: String]? {
        
        var errors: [String: String] = [:]
        
        if isNewUser {
            if let _ = try! self.usersRepository.get(byEmail: user.email) {
                errors["email"] = "User with following email exists."
            }
        }
        
        if user.name.isEmpty {
            errors["name"] = "Field is required."
        }
        
        if user.email.isEmpty {
            errors["email"] = "Field is required."
        }

        if user.password.isEmpty {
            errors["password"] = "Field is required."
        }
        
        return errors.count > 0 ? errors : nil
    }
}
