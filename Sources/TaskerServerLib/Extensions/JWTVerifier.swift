//
//  JWTVerifier.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 27.02.2018.
//

import Foundation
import PerfectCrypto

extension JWTVerifier {
    
    public func verifyExpirationDate() throws {
        if self.payload[ClaimsNames.expiration.rawValue] == nil {
            throw JWTTokenExpirationDateError.expiredDateNotExists
        }
        
        guard let date = extractDate() else {
            throw JWTTokenExpirationDateError.incorrectExpiredDate
        }
        
        if date.compare(Date()) == ComparisonResult.orderedAscending {
            throw JWTTokenExpirationDateError.tokenExpired
        }
    }
    
    private func extractDate() -> Date? {
        if let timestamp = self.payload[ClaimsNames.expiration.rawValue] as? TimeInterval {
            return Date(timeIntervalSince1970: timestamp)
        }
        
        if let timestamp = self.payload[ClaimsNames.expiration.rawValue] as? Int {
            return Date(timeIntervalSince1970: Double(timestamp))
        }
        
        if let timestampString = self.payload[ClaimsNames.expiration.rawValue] as? String, let timestamp = Double(timestampString) {
            return Date(timeIntervalSince1970: timestamp)
        }
        
        return nil
    }
}
