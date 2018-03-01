import XCTest
@testable import TaskerServerLib

XCTMain([
    testCase(HealthControllerTests.allTests),
    testCase(TasksControllerTests.allTests),
    testCase(UsersControllerTests.allTests)
])
