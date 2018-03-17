//
//  FakeUserRolesRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 01.03.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeUserRolesRepository: FakeBaseRepository<UserRole>, UserRolesRepositoryProtocol {

    let getForUserMock = Mock<(UUID)>()
    let getForUserStub = Stub<UUID, [Role]>()

    let setForUserMock = Mock<([Role]?, UUID)>()

    func get(forUserId id: UUID) throws -> [Role] {
        getForUserMock.record(id)
        return try getForUserStub.invoke((id))
    }

    func set(roles: [Role]?, forUserId userid: UUID) throws {
        setForUserMock.record((roles, userid))
    }
}
