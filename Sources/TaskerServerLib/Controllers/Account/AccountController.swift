//
//  AccountController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 26.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class AccountController: Controller {

    let registerAction: RegisterAction
    let signInAction: SignInAction
    let changePasswordAction: ChangePasswordAction

    init(configuration: Configuration, usersService: UsersServiceProtocol) {
        self.registerAction = RegisterAction(usersService: usersService)
        self.signInAction = SignInAction(configuration: configuration, usersService: usersService)
        self.changePasswordAction = ChangePasswordAction(usersService: usersService)
    }

    override func initRoutes() {
        self.register(self.registerAction)
        self.register(self.signInAction)
        self.register(self.changePasswordAction)
    }

    override func getDescription() -> String {
        return "Controller for managing user accout (registering/signing in/password)."
    }
}
