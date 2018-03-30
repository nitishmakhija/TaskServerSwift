//
//  AccountController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class AccountController: ControllerProtocol {

    private let actions: [ActionProtocol]

    init(configuration: Configuration, usersService: UsersServiceProtocol) {
        self.actions =  [
            RegisterAction(usersService: usersService),
            SignInAction(configuration: configuration, usersService: usersService),
            ChangePasswordAction(usersService: usersService)
        ]
    }

    func getMetadataName() -> String {
        return "Account"
    }

    func getMetadataDescription() -> String {
        return "Controller for managing user accout (registering/signing in/password)."
    }

    func getActions() -> [ActionProtocol] {
        return self.actions
    }
}
