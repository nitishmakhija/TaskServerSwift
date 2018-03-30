//
//  AuthorizationPolicy.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 29.03.2018.
//

public enum AuthorizationPolicy: Equatable {
    case anonymous
    case signedIn
    case inRole([String])

    static public func == (lhs: AuthorizationPolicy, rhs: AuthorizationPolicy) -> Bool {
        switch (lhs, rhs) {
        case (.anonymous, .anonymous):
            return true
        case (.signedIn, .signedIn):
            return true
        case (.inRole, .inRole):
            return true
        default:
            return false
        }
    }
}
