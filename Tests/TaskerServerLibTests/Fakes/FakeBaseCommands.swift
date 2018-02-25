//
//  FakeBaseCommands.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 25.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeBaseCommands<T: EntityProtocol> {
    
    let addMock = Mock<T>()
    let updateMock = Mock<T>()
    let deleteMock = Mock<Int>()
    
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
