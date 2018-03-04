import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import Dip
import TaskerServerLib
import Configuration

// Read configuration file.
let configurationManager = ConfigurationManager()
    .load(file: "configuration.json", relativeFrom: .pwd)
    .load(.environmentVariables)
    .load(.commandLineArguments)

let configuration = configurationManager.build()

// Configure dependency injection.
let container = DependencyContainer()
container.configure(withConfiguration: configuration)

// Initialize all controllers.
let controllers = container.resolveAllControllers()

// Routes and handlers.
var allRoutes = Routes()
allRoutes.configure(allRoutes: controllers)

// Run migrations.
let databaseContext = try! container.resolve() as DatabaseContextProtocol
try databaseContext.executeMigrations()

// Authorization.
var routesWithAuthorization = Routes()
routesWithAuthorization.configure(routesWithAuthorization: controllers)

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
    (AuthorizationFilter(secret: configuration.secret, routesWithAuthorization: routesWithAuthorization), HTTPFilterPriority.high)
]

// Resource-based authorization.
let authorizationService = try! container.resolve() as AuthorizationServiceProtocol
authorizationService.add(authorizationHandler: TaskOwnerAuthorizationHandler())


do {
    // Launch the HTTP server.
    try HTTPServer.launch(
        .server(
            name: configuration.serverName,
            port: configuration.serverPort,
            routes: allRoutes,
            requestFilters: requestFilters
        )
    )
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
