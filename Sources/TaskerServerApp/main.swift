import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import Dip
import TaskerServerLib

// Configure dependency injection.
let container = DependencyContainer()
container.configure()

// Initialize all controllers.
let controllers = container.resolveAllControllers()

// Routes and handlers.
var routes = Routes()
routes.configure(basedOnControllers: controllers)


do {
    // Launch the HTTP server.
    try HTTPServer.launch(
        .server(name: "www.example.ca", port: 8181, routes: routes))
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
