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
    
    let serverContext = try! TestServerContext()
    
    func testInitRoutesShouldInitializeGetAllUsersRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
   
        // Act.
        let requestHandler = serverContext.usersController.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetUserByIdRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)
        
        // Act.
        let requestHandler = serverContext.usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)
        
        // Act.
        let requestHandler = serverContext.usersController.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)
        
        // Act.
        let requestHandler = serverContext.usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteUserRoute() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)
        
        // Act.
        let requestHandler = serverContext.usersController.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)
        
        // Assert.
        XCTAssertNotNil(requestHandler)
    }
    
    func testGetUsersShouldReturnUsersCollection() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.all(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(Array<UserDto>.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertTrue(users.count > 0)
    }
    
    func testGetUserShouldReturnUserWhenWeProvideCorrectId() {
        
        // Arrange.
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        let userDto = try! fakeHttpResponse.getObjectFromResponseBody(UserDto.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(user.id, userDto.id)
        XCTAssertEqual(user.email, userDto.email)
    }
    
    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": UUID().uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.get(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let user = User(id: UUID(), createDate: Date(), name: "Martin Schmidt",
                        email: "martin.schmidt@emailx.com", password: "p@ssword", salt: "123", isLocked: true)
        fakeHttpRequest.addObjectToRequestBody(user)

        // Act.
        serverContext.usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let user = User(id: UUID(), createDate: Date(), name: "",
                        email: "robin.schmidt@emailx.com", password: "p@ssword", salt: "123", isLocked: true)
        fakeHttpRequest.addObjectToRequestBody(user)
        
        // Act.
        serverContext.usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let user = User(id: UUID(), createDate: Date(), name: "Robin Schmidt",
                        email: "", password: "p@ssword", salt: "123", isLocked: true)
        fakeHttpRequest.addObjectToRequestBody(user)
        
        // Act.
        serverContext.usersController.post(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let user = TestUsers.getVikiDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        fakeHttpRequest.addObjectToRequestBody(user)
        
        // Act.
        serverContext.usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }
    
    func testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName() {
        
        // Arrange.
        let user = TestUsers.getSamanthaDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        user.name = ""
        fakeHttpRequest.addObjectToRequestBody(user)
        
        // Act.
        serverContext.usersController.put(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        let user = TestUsers.getNorbiDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }
    
    func testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {
        
        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": UUID().uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.usersController.delete(request: fakeHttpRequest, response: fakeHttpResponse)
        
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
        ("testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName", testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName),
        ("testPostUserShouldReturnValidationErrorWhenWeProvideEmptyEmail", testPostUserShouldReturnValidationErrorWhenWeProvideEmptyEmail),
        ("testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData", testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData),
        ("testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson", testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson),
        ("testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName", testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName),
        ("testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId", testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId),
        ("testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId", testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId)
    ]
}
