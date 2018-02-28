//
//  FakeUsersRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 15.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeUsersRepository : FakeBaseRepository<User>, UsersRepositoryProtocol {
    
    let getByEmailMock = Mock<(String)>()
    let getByEmailStub = Stub<(String), User?>()
    
    func get(byEmail email: String) throws -> User? {
        getByEmailMock.record((email))
        return try! getByEmailStub.invoke((email))
    }
}
