//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

class UsersController : Controller {
    
    private let usersQueries: UsersQueriesProtocol!
    private let usersCommands: UsersCommandsProtocol!
    
    init(usersCommands: UsersCommandsProtocol, usersQueries: UsersQueriesProtocol) {
        self.usersCommands = usersCommands
        self.usersQueries = usersQueries
    }
    
    override func initRoutes() {
        routes.add(method: .get, uri: "/users", handler: getUsers)
        routes.add(method: .get, uri: "/users/{id}", handler: getUser)
        routes.add(method: .post, uri: "/users", handler: postUser)
        routes.add(method: .put, uri: "/users/{id}", handler: putUser)
        routes.add(method: .delete, uri: "/users/{id}", handler: deleteUser)
    }
    
    public func getUsers(request: HTTPRequest, response: HTTPResponse) {
        do {
            let users = try self.usersQueries.get()
            response.sendJson(users)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func getUser(request: HTTPRequest, response: HTTPResponse) {
        
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let user = try self.usersQueries.get(byId: id) {
                    return response.sendJson(user)
                }
                else {
                    return response.sendNotFoundError()
                }
            }
            
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func postUser(request: HTTPRequest, response: HTTPResponse) {
        do {
            let user = try request.getObjectFromRequest(User.self)
            try self.usersCommands.add(entity: user)
            return response.sendJson(user)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func putUser(request: HTTPRequest, response: HTTPResponse) {
        do {
            let user = try request.getObjectFromRequest(User.self)
            try self.usersCommands.update(entity: user)
            return response.sendJson(user)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func deleteUser(request: HTTPRequest, response: HTTPResponse) {
        do {
            if let stringId = request.urlVariables["id"], let id = Int(stringId) {
                if let _ = try self.usersQueries.get(byId: id) {
                    try self.usersCommands.delete(entityWithId: id)
                    return response.sendOk();
                }
                else {
                    return response.sendNotFoundError()
                }
            }
            
            response.sendBadRequestError()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
}
