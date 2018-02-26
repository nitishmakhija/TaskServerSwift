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
    
    let getByEmailAndPasswordMock = Mock<(String, String)>()
    let getByEmailAndPasswordStub = Stub<(String, String), User?>()
    
    func get(byEmail email: String, andPassword password: String) throws -> User? {
        getByEmailAndPasswordMock.record((email, password))
        return try! getByEmailAndPasswordStub.invoke((email, password))
    }
}
