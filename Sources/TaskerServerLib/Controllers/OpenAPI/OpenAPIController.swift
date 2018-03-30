//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class OpenAPIController: ControllerProtocol {

    private let openAPIAction = OpenAPIAction()

    public var controllers: [ControllerProtocol]? {
        didSet {
            openAPIAction.controllers = self.controllers
        }
    }

    public func getMetadataName() -> String {
        return "OpenAPI"
    }

    public func getMetadataDescription() -> String {
        return "Controller for OpenAPI metadata"
    }

    public func getActions() -> [ActionProtocol] {
        return [
            openAPIAction
        ]
    }
}
