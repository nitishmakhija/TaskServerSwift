//
//  TokenProvider.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 11.03.2018.
//

import Foundation
import PerfectCrypto

public class TokenProvider {

    private let issuer: String
    private let secret: String

    init(issuer: String, secret: String) {
        self.issuer = issuer
        self.secret = secret
    }

    public func prepareToken(user: User) throws -> String {

        let payload = [
            ClaimsNames.uid.rawValue: user.id.uuidString,
            ClaimsNames.name.rawValue: user.email,
            ClaimsNames.roles.rawValue: user.getRolesNames(),
            ClaimsNames.issuer.rawValue: self.issuer,
            ClaimsNames.issuedAt.rawValue: Date().timeIntervalSince1970,
            ClaimsNames.expiration.rawValue: Date().addingTimeInterval(36000).timeIntervalSince1970
            ] as [String: Any]

        guard let jwt = JWTCreator(payload: payload) else {
            throw PrepareTokenError()
        }

        let token = try jwt.sign(alg: .hs256, key: self.secret)
        return token
    }
}
