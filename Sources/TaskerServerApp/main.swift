import PerfectHTTP
import PerfectHTTPServer
import TaskerServerLib

do {
    let serverContext = try ServerContext()
    let server = HTTPServer()



    server.setRequestFilters(serverContext.requestFilters)
    server.serverName = serverContext.configuration.serverName
    server.serverPort = serverContext.configuration.serverPort
    server.addRoutes(serverContext.allRoutes)

    // Launch the HTTP server.
    try server.start()

} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
