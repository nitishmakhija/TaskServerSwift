//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

class UsersController: Controller {

    public let allUsers: AllUsersAction
    public let userByIdAction: UserByIdAction
    public let createUserAction: CreateUserAction
    public let updateUserAction: UpdateUserAction
    public let deleteUserAction: DeleteUserAction

    init(usersService: UsersServiceProtocol) {
        self.allUsers = AllUsersAction(usersService: usersService)
        self.userByIdAction = UserByIdAction(usersService: usersService)
        self.createUserAction = CreateUserAction(usersService: usersService)
        self.updateUserAction = UpdateUserAction(usersService: usersService)
        self.deleteUserAction = DeleteUserAction(usersService: usersService)
    }

    override func initRoutes() {
        self.register(self.allUsers)
        self.register(self.userByIdAction)
        self.register(self.createUserAction)
        self.register(self.updateUserAction)
        self.register(self.deleteUserAction)
    }

    override func getDescription() -> String {
        return "Controller for managing users."
    }
}
