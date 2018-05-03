//
//  UserRolesService.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 03.05.2018.
//

import Foundation

public protocol UserRolesServiceProtocol {
    func get(forUserId userId: UUID) throws -> [Role]

}

public class UserRolesService: UserRolesServiceProtocol {

    private let userRolesRepository: UserRolesRepositoryProtocol

    init(userRolesRepository: UserRolesRepositoryProtocol) {
        self.userRolesRepository = userRolesRepository
    }

    public func get(forUserId userId: UUID) throws -> [Role] {
        return try self.get(forUserId: userId)
    }
}
