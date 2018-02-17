//
//  FakeUsersRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 15.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeUsersRepository : UsersRepositoryProtocol {
    
    let getUsersMock = Mock<()>()
    let getUsersStub = Stub<(), [User]>()

    let getUserMock = Mock<Int>()
    let getUserStub = Stub<Int, User?>()

    let addUserMock = Mock<User>()
    let updateUserMock = Mock<User>()
    let deleteUserMock = Mock<Int>()
        
    func getUsers() -> [User] {
        getUsersMock.record(())
        return try! getUsersStub.invoke(())
    }
    
    func getUser(id: Int) -> User? {
        getUserMock.record(id)
        return try! getUserStub.invoke((id))
    }
    
    func addUser(user: User) {
        addUserMock.record(user)
    }
    
    func updateUser(user: User) {
        updateUserMock.record(user)
    }
    
    func deleteUser(id: Int) {
        deleteUserMock.record(id)
    }
}
