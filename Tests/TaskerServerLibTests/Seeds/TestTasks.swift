//
//  Tasks.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
import PerfectCRUD
@testable import TaskerServerLib

class TestTasks {

    public static var tasks: [Task] = []

    public class func getTask(_ name: String) -> Task {
        let task = tasks.first { (task) -> Bool in
            return task.name == name
        }

        return task!
    }

    public class func seed(databaseContext: DatabaseContext) throws {

        for index in 1...10 {
            tasks.append(Task(id: UUID(), createDate: Date(), name: "John \(index) task",
                isFinished: false, userId: TestUsers.getJohnDoe().id))
        }

        for index in 1...10 {
            tasks.append(Task(id: UUID(), createDate: Date(), name: "Viki \(index) task",
                isFinished: false, userId: TestUsers.getVikiDoe().id))
        }

        for task in tasks {
            try databaseContext.set(Task.self).insert(task)
        }
    }
}
