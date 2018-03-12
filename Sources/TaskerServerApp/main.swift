import PerfectHTTP
import TaskerServerLib

do {
    let serverContext = ServerContext()
        
    // Launch the HTTP server.
    try HTTPServer.launch(
        .server(
            name: serverContext.configuration.serverName,
            port: serverContext.configuration.serverPort,
            routes: serverContext.allRoutes,
            requestFilters: serverContext.requestFilters
        )
    )
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
