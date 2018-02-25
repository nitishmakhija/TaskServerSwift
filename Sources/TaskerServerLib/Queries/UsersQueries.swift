//
//  UsersRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectCRUD

public protocol UsersQueriesProtocol {
    func get() throws -> [User]
    func get(byId id: Int) throws -> User?
}

class UsersQueries : BaseQueries<User>, UsersQueriesProtocol {
}
