//
//  TasksControllerTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

// swiftlint:disable force_try

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class UsersControllerTests: XCTestCase {

    private var serverContext: TestServerContext!

    private var allUsersAction: ActionProtocol? {
        return serverContext.usersController.getAction(for: AllUsersAction.self)
    }

    private var userByIdAction: ActionProtocol? {
        return serverContext.usersController.getAction(for: UserByIdAction.self)
    }

    private var createUserAction: ActionProtocol? {
        return serverContext.usersController.getAction(for: CreateUserAction.self)
    }

    private var updateUserAction: ActionProtocol? {
        return serverContext.usersController.getAction(for: UpdateUserAction.self)
    }

    private var deleteUserAction: ActionProtocol? {
        return serverContext.usersController.getAction(for: DeleteUserAction.self)
    }

    override func setUp() {
        self.serverContext = TestServerContext.shared
    }

    func testInitRoutesShouldInitializeGetAllUsersRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializeGetUserByIdRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .get)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializePostUserRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/users", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializePutUserRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .put)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializeDeleteUserRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .delete)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/users/123", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testGetUsersShouldReturnUsersCollection() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        allUsersAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        let users = try! fakeHttpResponse.getObjectFromResponseBody(UsersDto.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertTrue(users.users.count > 0)
    }

    func testGetUserShouldReturnUserWhenWeProvideCorrectId() {

        // Arrange.
        let user = TestUsers.getJohnDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        userByIdAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        let userDto = try! fakeHttpResponse.getObjectFromResponseBody(UserDto.self)
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        XCTAssertEqual(user.id.uuidString, userDto.id)
        XCTAssertEqual(user.email, userDto.email)
    }

    func testGetUserShouldReturnNotFoundStatusCodeWhenWeProvideIncorrectId() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": UUID().uuidString])
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        userByIdAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.notFound.code, fakeHttpResponse.status.code)
    }

    func testPostUserShouldAddUserToStoreWhenWeProvideCorrectUserData() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        var user = UserDto(id: UUID(), createDate: Date(), name: "Martin Schmidt",
                        email: "martin.schmidt@emailx.com", isLocked: true)
        user.password = "password"
        fakeHttpRequest.addObjectToRequestBody(user)

        // Act.
        createUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }

    func testPostUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        createUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }

    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyName() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let user = UserDto(id: UUID(), createDate: Date(), name: "",
                        email: "robin.schmidt@emailx.com", isLocked: true)
        fakeHttpRequest.addObjectToRequestBody(user)

        // Act.
        createUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (error) -> Bool in
            return error.field == "name" && error.messages.first == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }

    func testPostUserShouldReturnValidationErrorWhenWeProvideEmptyEmail() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let user = UserDto(id: UUID(), createDate: Date(), name: "Robin Schmidt",
                        email: "", isLocked: true)
        fakeHttpRequest.addObjectToRequestBody(user)

        // Act.
        createUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (error) -> Bool in
            return error.field == "email" && error.messages.first == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }

    func testPutUserShouldUpdateUserInStoreWhenWeProvideCorrectUserData() {

        // Arrange.
        let user = TestUsers.getVikiDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString], withAuthorization: user)
        let fakeHttpResponse = FakeHTTPResponse()
        fakeHttpRequest.addObjectToRequestBody(UserDto(user: user))

        // Act.
        updateUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }

    func testPutUserShouldReturnBadRequestStatusCodeWhenWeNotProvideJson() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        updateUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
    }

    func testPutUserShouldReturnValidationErrorWhenWeProvideEmptyName() {

        // Arrange.
        let user = TestUsers.getSamanthaDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()
        user.name = ""
        fakeHttpRequest.addObjectToRequestBody(UserDto(user: user))

        // Act.
        updateUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.badRequest.code, fakeHttpResponse.status.code)
        let validationsError = try! fakeHttpResponse.getObjectFromResponseBody(ValidationErrorResponseDto.self)
        let errorExists = validationsError.errors.contains { (error) -> Bool in
            return error.field == "name" && error.messages.first == "Field is required."
        }
        XCTAssertTrue(errorExists)
    }

    func testDeleteUserShouldDeleteUserFromStoreWhenWeProvideCorrectUserId() {

        // Arrange.
        let user = TestUsers.getNorbiDoe()
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": user.id.uuidString])
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        deleteUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
    }

    func testDeleteUserShouldReturnNotFoundStatusCodeWhenWeNotProvideCorrectId() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(urlVariables: ["id": UUID().uuidString])
        let fakeHttpResponse = FakeHTTPResponse()

        // Act.
        deleteUserAction?.handler(request: fakeHttpRequest, response: fakeHttpResponse)

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
