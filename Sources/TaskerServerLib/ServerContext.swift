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
    
    public var requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)]!
    public var allRoutes: Routes!
    
    public var configuration: Configuration!
    public var container: DependencyContainer!
    public var controllers: [Controller]!
    public var databaseContext: DatabaseContextProtocol!
    public var authorizationService: AuthorizationServiceProtocol!
    
    public init() {
        self.initConfiguration()
        self.initDependencyContainer()
        self.initRoutes()
        self.initDatabase()
        self.initAuthorization()
        self.initResourceBasedAuthorization()
    }
    
    public func initConfiguration() {
        let configurationManager = ConfigurationManager()
            .load(file: "configuration.json", relativeFrom: .pwd)
            .load(.environmentVariables)
            .load(.commandLineArguments)
        
        self.configuration = configurationManager.build()
    }
    
    public func initDependencyContainer() {
        self.container = DependencyContainer()
        self.container.configure(withConfiguration: configuration)
    }
    
    public func initRoutes() {
        self.controllers = container.resolveAllControllers()
        
        allRoutes = Routes()
        allRoutes.configure(allRoutes: controllers)
    }
    
    public func initDatabase() {
        self.databaseContext = try! container.resolve() as DatabaseContextProtocol
        try! self.databaseContext.executeMigrations(policy: .reconcileTable)
    }
    
    public func initAuthorization() {
        var routesWithAuthorization = Routes()
        routesWithAuthorization.configure(routesWithAuthorization: controllers)
        
        requestFilters = [
            (AuthorizationFilter(secret: configuration.secret, routesWithAuthorization: routesWithAuthorization), HTTPFilterPriority.high)
        ]
    }
    
    public func initResourceBasedAuthorization() {
        authorizationService = try! container.resolve() as AuthorizationServiceProtocol
        authorizationService.add(authorizationHandler: TaskOperationAuthorizationHandler())
    }
}
