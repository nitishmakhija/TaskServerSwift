//
//  FakeTasksRepository.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 17.02.2018.
//

import Foundation
import TaskerServerLib
import Dobby

class FakeTasksRepository : TasksRepositoryProtocol {
    
    let getTasksMock = Mock<()>()
    let getTasksStub = Stub<(), [Task]>()
    
    let getTaskMock = Mock<Int>()
    let getTaskStub = Stub<Int, Task?>()
    
    let addTaskMock = Mock<Task>()
    let updateTaskMock = Mock<Task>()
    let deleteTaskMock = Mock<Int>()
    
    func getTasks() -> [Task] {
        getTasksMock.record(())
        return try! getTasksStub.invoke(())
    }
    
    func getTask(id: Int) -> Task? {
        getTaskMock.record(id)
        return try! getTaskStub.invoke((id))
    }
    
    func addTask(task: Task) {
        addTaskMock.record(task)
    }
    
    func updateTask(task: Task) {
        updateTaskMock.record(task)
    }
    
    func deleteTask(id: Int) {
        deleteTaskMock.record(id)
    }
}
