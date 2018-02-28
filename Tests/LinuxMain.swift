import XCTest
@testable import TaskerServerLib

XCTMain([
    testCase(HealthController.allTests),
    testCase(TasksController.allTests),
    testCase(UsersController.allTests)
])
