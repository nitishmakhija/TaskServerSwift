//
//  AuthorizationFilterTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.03.2018.
//

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class AuthorizationFilterTests : XCTestCase {
    
    func testFilterShouldCallCallbackFunctionIfRouteIsForAnonymousUser() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest()
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            callbackExpectation.fulfill()
        }
        
        // Assert.
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldReturnUnauthorizedWhenAuthorizationHeaderNotExists() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: nil)
   
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in

            switch result {
            case HTTPRequestFilterResult.continue:
                XCTFail("halt must be called")
            case HTTPRequestFilterResult.halt:
                print("Ok")
            case HTTPRequestFilterResult.execute:
                XCTFail("halt must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldReturnUnauthorizeWhenAuthorizationHeaderNotContainsBearer() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "123123")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                XCTFail("halt must be called")
            case HTTPRequestFilterResult.halt:
                print("Ok")
            case HTTPRequestFilterResult.execute:
                XCTFail("halt must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldReturnUnauthorizeWhenTokenIsNotCorrect() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "Bearer 22323423")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                XCTFail("halt must be called")
            case HTTPRequestFilterResult.halt:
                print("Ok")
            case HTTPRequestFilterResult.execute:
                XCTFail("halt must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldReturnUnauthorizeWhenTokenIsNotValid() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        let tokenProvider = TokenProvider(issuer: "tasker", secret: "WRONG SECRET")
        let token = try! tokenProvider.prepareToken(user: User(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@emailx", password: "", salt: "", isLocked: false))
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "Bearer \(token)")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                XCTFail("halt must be called")
            case HTTPRequestFilterResult.halt:
                print("Ok")
            case HTTPRequestFilterResult.execute:
                XCTFail("halt must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldReturnUnauthorizeWhenTokenExpired() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAZW1haWx4IiwiaXNzIjoidGFza2VyIiwiaWF0IjoxNTIxMDQzMDg2LjQ3OTM5LCJleHAiOjE1MjEwMDcwODYuNDc5MzksInJvbGVzIjpbXSwidWlkIjoiNTI3OUQ3NzktQkZCNi00MjY5LTg5RjAtRDA4ODVBODczOEE4In0.cSlXn32wofjbxgF6L1X2YFGZOMwB0IvOp7GkGCudKMA"
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "Bearer \(token)")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                XCTFail("halt must be called")
            case HTTPRequestFilterResult.halt:
                print("Ok")
            case HTTPRequestFilterResult.execute:
                XCTFail("halt must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.unauthorized.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldCallCallbackFunctionIfAuthorizationWasSuccessfull() {
        
        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        let tokenProvider = TokenProvider(issuer: "tasker", secret: "secret")
        let token = try! tokenProvider.prepareToken(user: User(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@emailx", password: "", salt: "", isLocked: false))
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "Bearer \(token)")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                print("Ok")
            case HTTPRequestFilterResult.halt:
                XCTFail("callback must be called")
            case HTTPRequestFilterResult.execute:
                XCTFail("callback must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFilterShouldSetUpUserCredentialsIfAuthorizationWasSuccessfull() {

        // Arrange.
        let route = Route(method: .get, uri: "/") { (request, response) in print("Hello") }
        let authorizationFilter = AuthorizationFilter(secret: "secret", routesWithAuthorization: Routes([route]))
        let fakeHttpRequest = FakeHTTPRequest(path: "/")
        let fakeHttpResponse = FakeHTTPResponse()
        let callbackExpectation = expectation(description: "AuthorizationFilter must call callback for anonymous routes")
        
        let tokenProvider = TokenProvider(issuer: "tasker", secret: "secret")
        let token = try! tokenProvider.prepareToken(user: User(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@emailx", password: "", salt: "", isLocked: false))
        
        fakeHttpRequest.headerMock.expect(equals(HTTPRequestHeader.Name.authorization))
        fakeHttpRequest.headerStub.on(equals(HTTPRequestHeader.Name.authorization), return: "Bearer \(token)")
        
        // Act.
        authorizationFilter.filter(request: fakeHttpRequest, response: fakeHttpResponse) { (result) in
            
            switch result {
            case HTTPRequestFilterResult.continue:
                print("Ok")
            case HTTPRequestFilterResult.halt:
                XCTFail("callback must be called")
            case HTTPRequestFilterResult.execute:
                XCTFail("callback must be called")
            }
            
            callbackExpectation.fulfill()
        }
        
        // Assert.
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeHttpResponse.status.code)
        guard let userCredentials = fakeHttpRequest.getUserCredentials() else {
            XCTFail("callback must be called")
            return
        }
        
        XCTAssertEqual("john.doe@emailx", userCredentials.name)
        
        waitForExpectations(timeout: 3000) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    static var allTests = [
        ("testFilterShouldCallCallbackFunctionIfRouteIsForAnonymousUser", testFilterShouldCallCallbackFunctionIfRouteIsForAnonymousUser),
        ("testFilterShouldReturnUnauthorizedWhenAuthorizationHeaderNotExists", testFilterShouldReturnUnauthorizedWhenAuthorizationHeaderNotExists),
        ("testFilterShouldReturnUnauthorizeWhenAuthorizationHeaderNotContainsBearer", testFilterShouldReturnUnauthorizeWhenAuthorizationHeaderNotContainsBearer),
        ("testFilterShouldReturnUnauthorizeWhenTokenIsNotCorrect", testFilterShouldReturnUnauthorizeWhenTokenIsNotCorrect),
        ("testFilterShouldReturnUnauthorizeWhenTokenIsNotValid", testFilterShouldReturnUnauthorizeWhenTokenIsNotValid),
        ("testFilterShouldReturnUnauthorizeWhenTokenExpired", testFilterShouldReturnUnauthorizeWhenTokenExpired),
        ("testFilterShouldCallCallbackFunctionIfAuthorizationWasSuccessfull", testFilterShouldCallCallbackFunctionIfAuthorizationWasSuccessfull),
        ("testFilterShouldSetUpUserCredentialsIfAuthorizationWasSuccessfull", testFilterShouldSetUpUserCredentialsIfAuthorizationWasSuccessfull)   
    ]
}
