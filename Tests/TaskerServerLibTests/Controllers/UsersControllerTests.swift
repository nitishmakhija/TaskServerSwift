//
//  TasksControllerTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class UsersControllerTests: XCTestCase {
    
    func testInitRoutesShouldInitializeGetAllUsersRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersRepository: fakeUsersRepository)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetUserByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersRepository: fakeUsersRepository)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersRepository: fakeUsersRepository)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersRepository: fakeUsersRepository)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersRepository: fakeUsersRepository)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetUsersShouldReturnUsersCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUserRepository = FakeUsersRepository()
        
        fakeUserRepository.getUsersStub.on(any(), return: [
                User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: false),
                User(id: 2, name: "Victor Doe", email: "victor.doe@emailx.com", isLocked: false)
        ])
        let usersController = UsersController(usersRepository: fakeUserRepository)
        
        // Act.
        usersController.getUsers(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(Array<User>.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(2, users.count)
        XCTAssertEqual("john.doe@emailx.com", users[0].email)
        XCTAssertEqual("victor.doe@emailx.com", users[1].email)
    }
    
    func testGetUserShouldReturnUserWhenWeProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUserRepository = FakeUsersRepository()
        
        fakeUserRepository.getUserStub.on(equals(1), return:
            User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: false)
        )
        let usersController = UsersController(usersRepository: fakeUserRepository)
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(User.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(1, users.id)
        XCTAssertEqual("john.doe@emailx.com", users.email)
    }
    
    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "2"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUserRepository = FakeUsersRepository()
        
        fakeUserRepository.getUserStub.on(equals(2), return: nil)
        let usersController = UsersController(usersRepository: fakeUserRepository)
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    static var allTests = [
        ("testInitRoutesShouldInitializeGetAllUsersRoute", testInitRoutesShouldInitializeGetAllUsersRoute),
        ("testInitRoutesShouldInitializeGetUserByIdRoute", testInitRoutesShouldInitializeGetUserByIdRoute),
        ("testInitRoutesShouldInitializePostUserRoute", testInitRoutesShouldInitializePostUserRoute),
        ("testInitRoutesShouldInitializePutUserRoute", testInitRoutesShouldInitializePutUserRoute),
        ("testInitRoutesShouldInitializeDeleteUserRoute", testInitRoutesShouldInitializeDeleteUserRoute),
        ("testGetUsersShouldReturnUsersCollection", testGetUsersShouldReturnUsersCollection),
        ("testGetUserShouldReturnUserWhenWeProvideCorrectId", testGetUserShouldReturnUserWhenWeProvideCorrectId),
        ("testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId", testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId)
    ]
}
