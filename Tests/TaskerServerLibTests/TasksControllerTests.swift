//
//  TasksControllerTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

import XCTest
import PerfectHTTP
@testable import TaskerServerLib

class TasksControllerTests: XCTestCase {
    
    func testInitRoutesShouldInitializeGetAllUsersRoute() {
        
        // Arrange.
        let httpRequest = FakeHTTPRequest(method: .get)
        
        // Act.
        let usersController = UsersController(usersRepository: UsersRepository())
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: httpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeGetUserByIdRoute() {
        
        // Arrange.
        let httpRequest = FakeHTTPRequest(method: .get)
        
        // Act.
        let usersController = UsersController(usersRepository: UsersRepository())
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: httpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePostUserRoute() {
        
        // Arrange.
        let httpRequest = FakeHTTPRequest(method: .post)
        
        // Act.
        let usersController = UsersController(usersRepository: UsersRepository())
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users", webRequest: httpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializePutUserRoute() {
        
        // Arrange.
        let httpRequest = FakeHTTPRequest(method: .put)
        
        // Act.
        let usersController = UsersController(usersRepository: UsersRepository())
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: httpRequest)
        XCTAssertNotNil(requestHandler)
    }
    
    func testInitRoutesShouldInitializeDeleteUserRoute() {
        
        // Arrange.
        let httpRequest = FakeHTTPRequest(method: .delete)
        
        // Act.
        let usersController = UsersController(usersRepository: UsersRepository())
        
        // Assert.
        let requestHandler = usersController.routes.navigator.findHandler(uri: "/users/123", webRequest: httpRequest)
        XCTAssertNotNil(requestHandler)
    }
    

    static var allTests = [
        ("testInitRoutesShouldInitializeGetAllUsersRoute", testInitRoutesShouldInitializeGetAllUsersRoute),
        ("testInitRoutesShouldInitializeGetUserByIdRoute", testInitRoutesShouldInitializeGetUserByIdRoute),
        ("testInitRoutesShouldInitializePostUserRoute", testInitRoutesShouldInitializePostUserRoute),
        ("testInitRoutesShouldInitializePutUserRoute", testInitRoutesShouldInitializePutUserRoute),
        ("testInitRoutesShouldInitializeDeleteUserRoute", testInitRoutesShouldInitializeDeleteUserRoute)
    ]
}
