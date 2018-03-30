//
//  OpenAPIController.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.03.2018.
//

import Foundation
import PerfectHTTP
import Swiftgger

public class OpenAPIController: Controller {

    private var openAPIAction: OpenAPIAction

    public var controllers: [Controller]? {
        didSet {
            self.openAPIAction.controllers = controllers
        }
    }

    override init() {
        self.openAPIAction = OpenAPIAction()
    }

    override func initRoutes() {
        self.register(openAPIAction)
    }
}
