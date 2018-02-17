//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

class UsersController : Controller {
    
    private let usersRepository: UsersRepositoryProtocol!
    
    init(usersRepository: UsersRepositoryProtocol) {
        self.usersRepository = usersRepository
    }
    
    override func initRoutes() {
        routes.add(method: .get, uri: "/users", handler: getUsers)
        routes.add(method: .get, uri: "/users/{id}", handler: getUser)
        routes.add(method: .post, uri: "/users", handler: postUser)
        routes.add(method: .put, uri: "/users/{id}", handler: putUser)
        routes.add(method: .delete, uri: "/users/{id}", handler: deleteUser)
    }
    
    public func getUsers(request: HTTPRequest, response: HTTPResponse) {
        let users = self.usersRepository.getUsers()
        response.sendJson(users)
    }
    
    public func getUser(request: HTTPRequest, response: HTTPResponse) {
        
        if let stringId = request.urlVariables["id"], let id = Int(stringId) {
            if let task = self.usersRepository.getUser(id: id) {
                return response.sendJson(task)
            }
        }
        
        response.sendNotFound()
    }
    
    public func postUser(request: HTTPRequest, response: HTTPResponse) {
        do {
            let user = try request.getObjectFromRequest(User.self)
            self.usersRepository.addUser(user: user)
            
            return response.sendJson(user)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func putUser(request: HTTPRequest, response: HTTPResponse) {
        do {
            let user = try request.getObjectFromRequest(User.self)
            self.usersRepository.updateUser(user: user)
            
            return response.sendJson(user)
        }
        catch {
            response.sendBadRequest()
        }
    }
    
    public func deleteUser(request: HTTPRequest, response: HTTPResponse) {
        if let stringId = request.urlVariables["id"], let id = Int(stringId) {
            self.usersRepository.deleteUser(id: id)
            return response.sendOk();
        }
        
        response.sendNotFound()
    }
}
