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
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Assert.
        let requestHandler = usersController.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetUserByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Assert.
        let requestHandler = usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Assert.
        let requestHandler = usersController.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Assert.
        let requestHandler = usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        let fakeUsersRepository = FakeUsersRepository()
        
        // Act.
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Assert.
        let requestHandler = usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetUsersShouldReturnUsersCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getMock.expect(any())
        fakeUsersRepository.getStub.on(any(), return: [
                User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false),
                User(id: 2, name: "Victor Doe", email: "victor.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        ])
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.getUsers(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(Array<UserDto>.self)
        fakeUsersRepository.getMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(2, users.count)
        XCTAssertEqual("john.doe@emailx.com", users[0].email)
        XCTAssertEqual("victor.doe@emailx.com", users[1].email)
    }
    
    func testGetUserShouldReturnUserWhenWeProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(1), return:
            User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        )
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(UserDto.self)
        fakeUsersRepository.getByIdMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(1, users.id)
        XCTAssertEqual("john.doe@emailx.com", users.email)
    }
    
    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "2"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(2), return: nil)
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.getUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        fakeUsersRepository.addMock.expect(matches({(user) -> Bool in
            user.id == 1 &&
            user.email == "john.doe@emailx.com" &&
            user.name == "John Doe" &&
            user.isLocked == true
        }))
        
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersRepository.addMock.verify()
    }
    
    func testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "name" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyEmail() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "John Doe", email: "", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.postUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "email" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(1), return:
            User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        )
        
        fakeUsersRepository.updateMock.expect(matches({(user) -> Bool in
            user.id == 1 &&
                user.email == "john.doe@emailx.com" &&
                user.name == "John Doe" &&
                user.isLocked == true
        }))
        
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.putUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersRepository.addMock.verify()
    }
    
    func testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.putUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false))
        fakeHttpRequest.addObjectToRequestBody(User(id: 1, name: "", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.putUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (key, value) -> Bool in
            return key == "name" && value == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }
    
    func testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: User(id: 1, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false))
        fakeUsersRepository.deleteMock.expect(matches({(id) -> Bool in id == 1 }))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.deleteUser(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersRepository.deleteMock.verify()
    }
    
    func testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": "1"])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: nil)
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
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
