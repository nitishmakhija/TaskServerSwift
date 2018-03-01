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
    
    func testInitRoutesShouldInitializeGetAllTasksRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeTasksRepository = FakeTasksRepository()
        
        // Act.
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Assert.
        let requestHandler = tasksController.allRoutes.navigator.findHandler(uri: "/tasks", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetTaskByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeTasksRepository = FakeTasksRepository()
        
        // Act.
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Assert.
        let requestHandler = tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        let fakeTasksRepository = FakeTasksRepository()
        
        // Act.
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Assert.
        let requestHandler = tasksController.allRoutes.navigator.findHandler(uri: "/tasks", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        let fakeTasksRepository = FakeTasksRepository()
        
        // Act.
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Assert.
        let requestHandler = tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteTaskRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        let fakeTasksRepository = FakeTasksRepository()
        
        // Act.
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Assert.
        let requestHandler = tasksController.allRoutes.navigator.findHandler(uri: "/tasks/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetTasksShouldReturnTasksCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getMock.expect(any())
        fakeTasksRepository.getStub.on(any(), return: [
            Task(id: UUID(), name: "Create unit tests", isFinished: false),
            Task(id: UUID(), name: "Create article", isFinished: true)
            ])
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.all(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let tasks = try! fakeHttpResponse.getObjectFromResponseBody(Array<Task>.self)
        fakeTasksRepository.getMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(2, tasks.count)
        XCTAssertEqual("Create unit tests", tasks[0].name)
        XCTAssertEqual("Create article", tasks[1].name)
    }
    
    func testGetTaskShouldReturnTaskWhenWeProvideCorrectId() {
        
        // Arrange.
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(equals(taskId), return:
            Task(id: taskId, name: "Create unit tests", isFinished: false)
        )
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let task = try! fakeHttpResponse.getObjectFromResponseBody(Task.self)
        fakeTasksRepository.getByIdMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(taskId, task.id)
        XCTAssertEqual("Create unit tests", task.name)
    }
    
    func testGetTaskShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(equals(taskId), return: nil)
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostTaskShouldAddTaskToStoreWhenWeProvideCorrectTaskData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        let taskId = UUID()
        fakeHttpRequest.addObjectToRequestBody(Task(id: taskId, name: "Create unit tests", isFinished: true))
        fakeTasksRepository.addMock.expect(matches({(task) -> Bool in
            task.id == taskId && task.name == "Create unit tests" && task.isFinished == true
        }))
        
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeTasksRepository.addMock.verify()
    }
    
    func testPostTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPostTaskShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        fakeHttpRequest.addObjectToRequestBody(Task(id: UUID(), name: "", isFinished: true))
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(equals(taskId), return: Task(id: taskId, name: "Before update", isFinished: true))
        
        fakeHttpRequest.addObjectToRequestBody(Task(id: taskId, name: "Create unit tests", isFinished: true))
        fakeTasksRepository.updateMock.expect(matches({(task) -> Bool in
            task.id == taskId && task.name == "Create unit tests" && task.isFinished == true
        }))
        
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeTasksRepository.addMock.verify()
    }
    
    func testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutTaskShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(equals(taskId), return: Task(id: taskId, name: "Create unit tests", isFinished: false))
        fakeHttpRequest.addObjectToRequestBody(Task(id: taskId, name: "", isFinished: true))
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "name" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectUserId() {
        
        // Arrange.
        let taskId = UUID();
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(any(), return: Task(id: taskId, name: "Create article", isFinished: true))
        fakeTasksRepository.deleteMock.expect(matches({(id) -> Bool in id == taskId }))
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeTasksRepository.deleteMock.verify()
    }
    
    func testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let taskId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": taskId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeTasksRepository = FakeTasksRepository()
        
        fakeTasksRepository.getByIdMock.expect(any())
        fakeTasksRepository.getByIdStub.on(any(), return: nil)
        let tasksController = TasksController(tasksService: TasksService(tasksRepository: fakeTasksRepository))
        
        // Act.
        tasksController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        ("testPutTaskShouldUpdateUserInStoreWhenWeProvideCorrectTaskData", testPutTaskShouldUpdateUserInStoreWhenWeProvideCorrectTaskData),
        ("testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPutTaskShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectUserId", testDeleteTaskShouldDeleteTaskFromStoreWhenWeProvideCorrectUserId),
        ("testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId", testDeleteTaskShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId)
    ]
}
