import PerfectHTTP
import PerfectHTTPServer
import TaskerServerLib
import Foundation

do {
    let serverContext = try ServerContext()
    let server = HTTPServer()

    server.setRequestFilters(serverContext.requestFilters)
    // server.serverName = serverContext.configuration.serverName
    server.serverPort = 8181
    server.addRoutes(serverContext.allRoutes)

    // Launch the HTTP server.
    try server.start()

} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
