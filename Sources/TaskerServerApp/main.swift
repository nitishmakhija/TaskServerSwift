import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import TaskerServerLib

do {
    let serverContext = try ServerContext()
    let server = HTTPServer()

    SessionConfig.name = "TestingMemoryDrivers"
    SessionConfig.idle = 3600

    SessionConfig.CORS.enabled = true
    SessionConfig.CORS.acceptableHostnames = ["*"]
    SessionConfig.CORS.methods = [.get, .post, .put]
    SessionConfig.CORS.maxAge = 60


    let sessionDriver = SessionMemoryDriver()

    server.setRequestFilters(serverContext.requestFilters + [sessionDriver.requestFilter])
    server.setResponseFilters([sessionDriver.responseFilter])

    server.serverName = serverContext.configuration.serverName
    server.serverPort = serverContext.configuration.serverPort
    server.addRoutes(serverContext.allRoutes)

    // Launch the HTTP server.
    try server.start()

} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
