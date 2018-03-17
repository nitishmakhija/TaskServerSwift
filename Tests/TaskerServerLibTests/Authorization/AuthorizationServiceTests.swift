//
//  AuthorizationServiceTests.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 16.03.2018.
//

// swiftlint:disable force_try

import XCTest
import PerfectHTTP
import Dobby
@testable import TaskerServerLib

class AuthorizationServiceTests: XCTestCase {

    func testServiceShouldReturnFalseWhenRequirementsNotExists() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: UUID())

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task,
                                                     requirement: OperationAuthorizationRequirement(operation: .read))

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnFalseWhenRequirementsNotFounded() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let user = User(id: UUID(), createDate: Date(), name: "Martin Schmidt",
                        email: "martin.schmidt@emailx.com", password: "p@ssword", salt: "123", isLocked: true)

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: user,
                                                          requirement: OperationAuthorizationRequirement(operation: .read))

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnFalseWhenHandlerReturnsFalse() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: UUID())

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task,
                                                          requirement: OperationAuthorizationRequirement(operation: .read))

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnTrueWhenHandlerReturnsTrue() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: userCredentials.id)

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task,
                                                          requirement: OperationAuthorizationRequirement(operation: .read))

        // Assert.
        XCTAssertEqual(true, result)
    }

    func testServiceShouldReturnFalseWhenPoliciesNotExists() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: UUID())

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task, policy: "Unknown")

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnFalseWhenPolicyNotFounded() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let user = User(id: UUID(), createDate: Date(), name: "Martin Schmidt",
                        email: "martin.schmidt@emailx.com", password: "p@ssword", salt: "123", isLocked: true)

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)
        authtorizationService.add(policy: "POLICY", requirements: [OperationAuthorizationRequirement(operation: .read)])

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: user, policy: "NOT_FOUNDED")

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnFalseWhenPolicyFoundedWithoutRequirements() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let user = User(id: UUID(), createDate: Date(), name: "Martin Schmidt",
                        email: "martin.schmidt@emailx.com", password: "p@ssword", salt: "123", isLocked: true)

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)
        authtorizationService.add(policy: "POLICY", requirements: [OperationAuthorizationRequirement(operation: .read)])

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: user, policy: "POLICY")

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnFalseWhenPolicyFoundedWithRequirementsAndHandlerReturnFalse() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: UUID())

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)
        authtorizationService.add(policy: "POLICY", requirements: [OperationAuthorizationRequirement(operation: .read)])

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task, policy: "POLICY")

        // Assert.
        XCTAssertEqual(false, result)
    }

    func testServiceShouldReturnTrueWhenPolicyFoundedWithRequirementsAndHandlerReturnTrue() {

        // Arrange.
        let authtorizationService = AuthorizationService()
        let userCredentials = UserCredentials(id: UUID(), name: "martin.schmidt@emailx.con", roles: [])
        let task = Task(id: UUID(), createDate: Date(), name: "Create unit tests", isFinished: true, userId: userCredentials.id)

        let taskOperationAuthorizationHandler = TaskOperationAuthorizationHandler()
        authtorizationService.add(authorizationHandler: taskOperationAuthorizationHandler)
        authtorizationService.add(policy: "POLICY", requirements: [OperationAuthorizationRequirement(operation: .read)])

        // Act.
        let result = try! authtorizationService.authorize(user: userCredentials, resource: task, policy: "POLICY")

        // Assert.
        XCTAssertEqual(true, result)
    }

    static var allTests = [
        ("testServiceShouldReturnFalseWhenRequirementsNotExists", testServiceShouldReturnFalseWhenRequirementsNotExists),
        ("testServiceShouldReturnFalseWhenRequirementsNotFounded", testServiceShouldReturnFalseWhenRequirementsNotFounded),
        ("testServiceShouldReturnFalseWhenHandlerReturnsFalse", testServiceShouldReturnFalseWhenHandlerReturnsFalse),
        ("testServiceShouldReturnTrueWhenHandlerReturnsTrue", testServiceShouldReturnTrueWhenHandlerReturnsTrue),
        ("testServiceShouldReturnFalseWhenPoliciesNotExists", testServiceShouldReturnFalseWhenPoliciesNotExists),
        ("testServiceShouldReturnFalseWhenPolicyNotFounded", testServiceShouldReturnFalseWhenPolicyNotFounded),
        ("testServiceShouldReturnFalseWhenPolicyFoundedWithoutRequirements",
            testServiceShouldReturnFalseWhenPolicyFoundedWithoutRequirements),
        ("testServiceShouldReturnFalseWhenPolicyFoundedWithRequirementsAndHandlerReturnFalse",
            testServiceShouldReturnFalseWhenPolicyFoundedWithRequirementsAndHandlerReturnFalse),
        ("testServiceShouldReturnTrueWhenPolicyFoundedWithRequirementsAndHandlerReturnTrue",
            testServiceShouldReturnTrueWhenPolicyFoundedWithRequirementsAndHandlerReturnTrue)
    ]
}
