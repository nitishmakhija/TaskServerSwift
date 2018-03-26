//
//  Server.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import Dip
import Configuration

open class ServerContext {

    public var requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = []
    public var allRoutes: Routes!

    public var configuration: Configuration!
    public var container: DependencyContainer!
    public var controllers: [Controller]!
    public var databaseContext: DatabaseContextProtocol!
    public var authorizationService: AuthorizationServiceProtocol!
    public var openAPIController: OpenAPIController!

    public init() throws {
        self.initConfiguration()
        try self.initDependencyContainer()
        self.initCORS()
        try self.initRoutes()
        try self.initDatabase()
        self.initAuthorization()
        try self.initResourceBasedAuthorization()
    }

    public func initConfiguration() {
        let configurationManager = ConfigurationManager()
            .load(file: "configuration.json", relativeFrom: .pwd)
            .load(.environmentVariables)
            .load(.commandLineArguments)

        self.configuration = configurationManager.build()
    }

    public func initDependencyContainer() throws {
        self.container = DependencyContainer()
        try self.container.configure(withConfiguration: configuration)
    }

    public func initCORS() {
        let corsFilter = CORSFilter()
        requestFilters.append((corsFilter, HTTPFilterPriority.high))
    }

    public func initRoutes() throws {
        self.controllers = try container.resolveAllControllers()

        allRoutes = Routes()
        allRoutes.configure(allRoutes: controllers)
    }

    public func initDatabase() throws {
        self.databaseContext = try container.resolve() as DatabaseContextProtocol
        try self.databaseContext.executeMigrations(policy: .reconcileTable)
    }

    public func initAuthorization() {
        var routesWithAuthorization = Routes()
        routesWithAuthorization.configure(routesWithAuthorization: controllers)

        let authorizationFilter = AuthorizationFilter(secret: configuration.secret, routesWithAuthorization: routesWithAuthorization)
        requestFilters.append((authorizationFilter, HTTPFilterPriority.medium))
    }

    public func initResourceBasedAuthorization() throws {
        authorizationService = try container.resolve() as AuthorizationServiceProtocol
        authorizationService.add(authorizationHandler: TaskOperationAuthorizationHandler())
    }
}
