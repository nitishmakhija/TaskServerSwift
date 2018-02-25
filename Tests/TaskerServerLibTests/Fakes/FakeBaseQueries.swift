//
//  FakeBaseRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeBaseQueries<T: EntityProtocol> {
    
    let getMock = Mock<()>()
    let getStub = Stub<(), [T]>()
    
    let getByIdMock = Mock<Int>()
    let getByIdStub = Stub<Int, T?>()
    
    func get() -> [T] {
        getMock.record(())
        return try! getStub.invoke(())
    }
    
    func get(byId id: Int) -> T? {
        getByIdMock.record(id)
        return try! getByIdStub.invoke((id))
    }
}
