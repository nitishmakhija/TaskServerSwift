//
//  TasksControllerTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 15.02.2018.
//

import Foundation

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class TasksControllerTests: XCTestCase {
    
    let serverContext = try! TestServerContext()
    
    func testInitRoutesShouldInitializeGetAllTasksRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        
        // Act.
        let requestHandler = serverContext.tasksController.allRoutes.navigator.findHandler(uri: "/tasks", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetTaskByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        
        // Act.
        let requestHandler = serverContext.tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        
        // Act.
        let requestHandler = serverContext.tasksController.allRoutes.navigator.findHandler(uri: "/tasks", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        
        // Act.
        let requestHandler = serverContext.tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        
        // Assert.
        
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        
        // Act.
        let requestHandler = serverContext.tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        
        // Assert.
        
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetTasksShouldReturnTasksCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
   
        // Act.
        serverContext.tasksController.all(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        
        let tasks = try! fakeHttpResponse.getObjectFromResponseBody(Array<TaskDto>.self)
        XCTAssertTrue(tasks.count > 0)
    }
    
    func testGetTaskShouldReturnTaskWhenWeProvideCorrectId() {
        
        // Arrange.
        let task = TestTasks.getTask("John 1 task")
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": task.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        serverContext.tasksController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let taskDto = try! fakeHttpResponse.getObjectFromResponseBody(TaskDto.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(task.id, taskDto.id)
        XCTAssertEqual(task.name, taskDto.name)
    }
    
    func testGetTaskShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": UUID().uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.tasksController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostTaskShouldAddTaskToStoreWhenWeProvideCorrectTaskData() {
        
        // Arrange.
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        fakeHttpRequest.addObjectToRequestBody(Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: user.id))
        
        // Act.
        serverContext.tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testPostTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(withAuthorization: TestUsers.getJohnDoe())
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPostTaskShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        fakeHttpRequest.addObjectToRequestBody(Task(id: UUID(), createDate: Date(), name: "", isFinished: true, userId: user.id))
        
        // Act.
        serverContext.tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "name" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testPutTaskShouldUpdateUserInStoreWhenWeProvideCorrectTaskData() {
        
        // Arrange.
        let task = TestTasks.getTask("John 9 task")
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": task.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        fakeHttpRequest.addObjectToRequestBody(task)

        // Act.
        serverContext.tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(withAuthorization: TestUsers.getJohnDoe())
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutTaskShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let task = TestTasks.getTask("John 9 task")
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": task.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        task.name = ""
        fakeHttpRequest.addObjectToRequestBody(task)
        
        // Act.
        serverContext.tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "name" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectTaskId() {
        
        // Arrange.
        let task = TestTasks.getTask("John 10 task")
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": task.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.tasksController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString], withAuthorization: TestUsers.getJohnDoe())
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.tasksController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    static var allTests = [
        ("testInitRoutesShouldInitializeGetAllTasksRoute", testInitRoutesShouldInitializeGetAllTasksRoute),
        ("testInitRoutesShouldInitializeGetTaskByIdRoute", testInitRoutesShouldInitializeGetTaskByIdRoute),
        ("testInitRoutesShouldInitializePostTaskRoute", testInitRoutesShouldInitializePostTaskRoute),
        ("testInitRoutesShouldInitializePutTaskRoute", testInitRoutesShouldInitializePutTaskRoute),
        ("testInitRoutesShouldInitializeDeleteTaskRoute", testInitRoutesShouldInitializeDeleteTaskRoute),
        ("testGetTasksShouldReturnTasksCollection", testGetTasksShouldReturnTasksCollection),
        ("testGetTaskShouldReturnTaskWhenWeProvideCorrectId", testGetTaskShouldReturnTaskWhenWeProvideCorrectId),
        ("testGetTaskShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId", testGetTaskShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId),
        ("testPostTaskShouldAddTaskToStoreWhenWeProvideCorrectTaskData", testPostTaskShouldAddTaskToStoreWhenWeProvideCorrectTaskData),
        ("testPostTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPostTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testPostTaskShouldReturnValidationErrorWhenWeProvideEmptyName", testPostTaskShouldReturnValidationErrorWhenWeProvideEmptyName),
        ("testPutTaskShouldUpdateUserInStoreWhenWeProvideCorrectTaskData", testPutTaskShouldUpdateUserInStoreWhenWeProvideCorrectTaskData),
        ("testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testPutTaskShouldReturnValidationErrorWhenWeProvideEmptyName", testPutTaskShouldReturnValidationErrorWhenWeProvideEmptyName),
        ("testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectTaskId", testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectTaskId),
        ("testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId", testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId)
    ]
}
