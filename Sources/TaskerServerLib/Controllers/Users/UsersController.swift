//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UsersController: ControllerProtocol {

    private let actions: [ActionProtocol]

    init(usersService: UsersServiceProtocol) {
        self.actions = [
            AllUsersAction(usersService: usersService),
            UserByIdAction(usersService: usersService),
            CreateUserAction(usersService: usersService),
            UpdateUserAction(usersService: usersService),
            DeleteUserAction(usersService: usersService)
        ]
    }

    func getMetadataName() -> String {
        return "Users"
    }

    func getMetadataDescription() -> String {
        return "Controller for managing users."
    }

    func getActions() -> [ActionProtocol] {
        return self.actions
    }
}
