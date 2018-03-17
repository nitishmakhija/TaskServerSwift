//
//  Users.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
import PerfectCRUD
@testable import TaskerServerLib

class TestUsers {

    private static var salt = "P7fnbMAvQtNs7D"
    private static var password = "puRzwuWcLYq3oq6VQSbGpyWPmZ0gD47cUVJegnz7o50"

    public static var users = [
        User(id: UUID(), createDate: Date(), name: "John Doe", email: "john.doe@taskserver.com",
             password: password, salt: salt, isLocked: false),
        User(id: UUID(), createDate: Date(), name: "Viki Doe", email: "viki.doe@taskserver.com",
             password: password, salt: salt, isLocked: false),
        User(id: UUID(), createDate: Date(), name: "Martin Doe", email: "martin.doe@taskserver.com",
             password: password, salt: salt, isLocked: false),
        User(id: UUID(), createDate: Date(), name: "Samantha Doe", email: "samantha.doe@taskserver.com",
             password: password, salt: salt, isLocked: false),
        User(id: UUID(), createDate: Date(), name: "Norbi Doe", email: "norbi.doe@taskserver.com",
             password: password, salt: salt, isLocked: false)
    ]

    public class func getJohnDoe() -> User {
        return users[0]
    }

    public class func getVikiDoe() -> User {
        return users[1]
    }

    public class func getMartinDoe() -> User {
        return users[2]
    }

    public class func getSamanthaDoe() -> User {
        return users[3]
    }

    public class func getNorbiDoe() -> User {
        return users[4]
    }

    public class func seed(databaseContext: DatabaseContext) throws {
        for user in users {
            try databaseContext.set(User.self).insert(user)
        }
    }
}
