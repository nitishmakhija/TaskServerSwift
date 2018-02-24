//
//  FakeBaseRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeBaseRepository<T: EntityProtocol> {
    
    let getMock = Mock<()>()
    let getStub = Stub<(), [T]>()
    
    let getByIdMock = Mock<Int>()
    let getByIdStub = Stub<Int, T?>()
    
    let addMock = Mock<T>()
    let updateMock = Mock<T>()
    let deleteMock = Mock<Int>()
    
    func get() -> [T] {
        getMock.record(())
        return try! getStub.invoke(())
    }
    
    func get(byId id: Int) -> T? {
        getByIdMock.record(id)
        return try! getByIdStub.invoke((id))
    }
    
    func add(entity: T) {
        addMock.record(entity)
    }
    
    func update(entity: T) {
        updateMock.record(entity)
    }
    
    func delete(entityWithId id: Int) {
        deleteMock.record(id)
    }
}
