//
//  AccountControllerTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 16.03.2018.
//

import Foundation

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class AccountControllerTests: XCTestCase {

    private var serverContext: TestServerContext!

    override func setUp() {
        self.serverContext = TestServerContext.shared
    }

    func testInitRoutesShouldInitializeRegisterRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/account/register", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializeSignInRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/account/sign-in", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    func testInitRoutesShouldInitializeChangePasswordRoute() {

        // Arrange.
        let fakeHttpRequest = FakeHTTPRequest(method: .post)

        // Act.
        let requestHandler = serverContext.allRoutes.navigator.findHandler(uri: "/account/change-password", webRequest: fakeHttpRequest)

        // Assert.
        XCTAssertNotNil(requestHandler)
    }

    static var allTests = [
        ("testInitRoutesShouldInitializeRegisterRoute", testInitRoutesShouldInitializeRegisterRoute),
        ("testInitRoutesShouldInitializeSignInRoute", testInitRoutesShouldInitializeSignInRoute),
        ("testInitRoutesShouldInitializeChangePasswordRoute", testInitRoutesShouldInitializeChangePasswordRoute)
    ]
}
