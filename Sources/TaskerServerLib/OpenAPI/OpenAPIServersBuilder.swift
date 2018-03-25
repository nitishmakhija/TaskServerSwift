//
//  OpenAPIServerBuilder.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.03.2018.
//

import Foundation

public class OpenAPIServersBuilder {

    let servers: [APIServer]

    init(servers: [APIServer]) {
        self.servers = servers
    }

    func build() -> [OpenAPIServer] {
        var openAPIServers: [OpenAPIServer] = []

        for server in self.servers {
            let server = OpenAPIServer(url: server.url, description: server.description, variables: server.variables)
            openAPIServers.append(server)
        }

        return openAPIServers
    }
}
