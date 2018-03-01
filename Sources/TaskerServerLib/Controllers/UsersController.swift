//
//  UsersController.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation
import PerfectHTTP

class UsersController : Controller {
    
    private let usersService: UsersServiceProtocol!
    
    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }
    
    override func initRoutes() {
        self.add(method: .get, uri: "/users", authorization: .inRole(["Administrator"]), handler: all)
        self.add(method: .get, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: get)
        self.add(method: .post, uri: "/users", authorization: .inRole(["Administrator"]), handler: post)
        self.add(method: .put, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: put)
        self.add(method: .delete, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: delete)
    }
    
    public func all(request: HTTPRequest, response: HTTPResponse) {
        do {
            let users = try self.usersService.get()

            var usersDtos: [UserDto] = []
            for user in users {
                usersDtos.append(UserDto(user: user))
            }
            
            response.sendJson(usersDtos)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func get(request: HTTPRequest, response: HTTPResponse) {
        
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let user = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }
            
            let userDto = UserDto(user: user)
            return response.sendJson(userDto)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func post(request: HTTPRequest, response: HTTPResponse) {
        do {
            let createUserDto = try request.getObjectFromRequest(RegisterUserDto.self)
            let user = createUserDto.toUser()
            
            try self.usersService.add(entity: user)
            
            guard let addedUser = try self.usersService.get(byId: user.id) else {
                return response.sendNotFoundError()
            }
            
            let addedUserDto = UserDto(user: addedUser)
            return response.sendJson(addedUserDto)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func put(request: HTTPRequest, response: HTTPResponse) {
        do {
            let userDto = try request.getObjectFromRequest(UserDto.self)

            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let user = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }
            
            user.name = userDto.name
            user.isLocked = userDto.isLocked
            user.roles = userDto.getRoles()
            
            try self.usersService.update(entity: user)
            
            guard let updatedUser = try self.usersService.get(byId: user.id) else {
                return response.sendNotFoundError()
            }
            
            let updatedUserDto = UserDto(user: updatedUser)
            return response.sendJson(updatedUserDto)
        }
        catch let error where error is DecodingError || error is RequestError {
            response.sendBadRequestError()
        }
        catch let error as ValidationsError {
            response.sendValidationsError(error: error)
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
    
    public func delete(request: HTTPRequest, response: HTTPResponse) {
        do {
            guard let stringId = request.urlVariables["id"], let id = UUID(uuidString: stringId) else {
                return response.sendBadRequestError()
            }

            guard let _ = try self.usersService.get(byId: id) else {
                return response.sendNotFoundError()
            }
            
            try self.usersService.delete(entityWithId: id)
            return response.sendOk()
        }
        catch {
            response.sendInternalServerError(error: error)
        }
    }
}
