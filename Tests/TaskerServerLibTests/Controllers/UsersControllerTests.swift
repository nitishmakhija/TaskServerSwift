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
                User(id: UUID(), name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false),
                User(id: UUID(), name: "Victor Doe", email: "victor.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        ])
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.all(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(userId), return:
            User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        )
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(UserDto.self)
        fakeUsersRepository.getByIdMock.verify()
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(userId, users.id)
        XCTAssertEqual("john.doe@emailx.com", users.email)
    }
    
    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(userId), return: nil)
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        fakeUsersRepository.addMock.expect(matches({(user) -> Bool in
            user.id == userId &&
            user.email == "john.doe@emailx.com" &&
            user.name == "John Doe" &&
            user.isLocked == true
        }))
        
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        fakeHttpRequest.addObjectToRequestBody(User(id: UUID(), name: "", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        fakeHttpRequest.addObjectToRequestBody(User(id: UUID(), name: "John Doe", email: "", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeHttpRequest.addObjectToRequestBody(User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(equals(userId), return:
            User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false)
        )
        
        fakeUsersRepository.updateMock.expect(matches({(user) -> Bool in
            user.id == userId &&
                user.email == "john.doe@emailx.com" &&
                user.name == "John Doe" &&
                user.isLocked == true
        }))
        
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false))
        fakeHttpRequest.addObjectToRequestBody(User(id: userId, name: "", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: true))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: User(id: userId, name: "John Doe", email: "john.doe@emailx.com", password: "pass", salt: "123", isLocked: false))
        fakeUsersRepository.deleteMock.expect(matches({(id) -> Bool in id == userId }))
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        fakeUsersRepository.deleteMock.verify()
    }
    
    func testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let userId = UUID()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": userId.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        let fakeUsersRepository = FakeUsersRepository()
        
        fakeUsersRepository.getByIdMock.expect(any())
        fakeUsersRepository.getByIdStub.on(any(), return: nil)
        let usersController = UsersController(usersService: UsersService(usersRepository: fakeUsersRepository))
        
        // Act.
        usersController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
