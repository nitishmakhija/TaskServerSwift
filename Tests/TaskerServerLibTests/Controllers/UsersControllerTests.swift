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
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        // Act.
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetUserByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        // Act.
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        // Act.
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        // Act.
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        // Act.
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetUsersShouldReturnUsersCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeUsersQueries.getMock.expect(any())
        fakeUsersQueries.getStub.on(any(), return: [
                User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: false),
                User(id: 2, name: "Victor Doe", email: "victor.doe@emailx.com", isLocked: false)
        ])
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.getUsers(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(Array<User>.self)
        fakeUsersQueries.getMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(2, users.count)
        XCTAssertEqual("john.doe@emailx.com", users[0].email)
        XCTAssertEqual("victor.doe@emailx.com", users[1].email)
    }
    
    func testGetUserShouldReturnUserWhenWeProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeUsersQueries.getByIdMock.expect(any())
        fakeUsersQueries.getByIdStub.on(equals(1), return:
            User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: false)
        )
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(User.self)
        fakeUsersQueries.getByIdMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(1, users.id)
        XCTAssertEqual("john.doe@emailx.com", users.email)
    }
    
    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "2"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeUsersQueries.getByIdMock.expect(any())
        fakeUsersQueries.getByIdStub.on(equals(2), return: nil)
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: true))
        fakeUsersCommands.addMock.expect(matches({(user) -> Bool in
            user.id == 1 &&
            user.email == "john.doe@emailx.com" &&
            user.name == "John Doe" &&
            user.isLocked == true
        }))
        
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersCommands.addMock.verify()
    }
    
    func testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: true))
        fakeUsersCommands.updateMock.expect(matches({(user) -> Bool in
            user.id == 1 &&
                user.email == "john.doe@emailx.com" &&
                user.name == "John Doe" &&
                user.isLocked == true
        }))
        
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.putUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersCommands.updateMock.verify()
    }
    
    func testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.putUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeUsersQueries.getByIdMock.expect(any())
        fakeUsersQueries.getByIdStub.on(any(), return: User(id: 1, name: "John Doe", email: "john.doe@emailx.com", isLocked: false))
        fakeUsersCommands.deleteMock.expect(matches({(id) -> Bool in id == 1 }))
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.deleteUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersCommands.deleteMock.verify()
    }
    
    func testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersQueries = FakeUsersQueries()
        let fakeUsersCommands = FakeUsersCommands()
        
        fakeUsersQueries.getByIdMock.expect(any())
        fakeUsersQueries.getByIdStub.on(any(), return: nil)
        let usersController = UsersController(usersCommands: fakeUsersCommands, usersQueries: fakeUsersQueries)
        
        // Act.
        usersController.deleteUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        ("testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId", testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId),
        ("testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData", testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData),
        ("testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData", testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData),
        ("testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId", testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId),
        ("testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId", testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId)
    ]
}
