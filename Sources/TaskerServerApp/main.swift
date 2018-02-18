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
var routes = Routes()
routes.configure(basedOnControllers: controllers)


do {
    // Launch the HTTP server.
    try HTTPServer.launch(
        .server(name: configuration.serverName, port: configuration.serverPort, routes: routes))
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
