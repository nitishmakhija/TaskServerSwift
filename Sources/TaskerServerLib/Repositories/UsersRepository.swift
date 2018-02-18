//
//  UsersRepository.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 12.02.2018.
//

import Foundation

public protocol UsersRepositoryProtocol {
    func getUsers() -> [User]
    func getUser(id: Int) -> User?
    func addUser(user: User)
    func updateUser(user: User)
    func deleteUser(id: Int)
}

class UsersRepository : UsersRepositoryProtocol {
    
    var users = [
        1: User(id: 1, name: "John Doe", email: "john.doe@xemail.com", isLocked: false),
        2: User(id: 2, name: "Marc Dribble", email: "mar.dribble@xemail.com", isLocked: false),
        3: User(id: 3, name: "Jim Bean", email: "jim.bean@xemail.com", isLocked: false),
        4: User(id: 4, name: "Anna Qui", email: "anna.qui@xemail.com", isLocked: false)
    ]
    
    init(configuration: Configuration) {
        print("Database host: \(configuration.databaseHost)")
    }
    
    func getUsers() -> [User] {
        return Array(self.users.values)
    }
    
    func getUser(id: Int) -> User? {
        let filteredUsers = self.users.values.filter { (user) -> Bool in
            return user.id == id
        }
        
        return filteredUsers.first
    }
    
    func addUser(user: User) {
        self.users[user.id] = user
    }
    
    func updateUser(user: User) {
        self.users[user.id] = user
    }
    
    func deleteUser(id: Int) {
        self.users.removeValue(forKey: id)
    }
    
}
