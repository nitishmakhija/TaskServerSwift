//
//  UUID.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 01.03.2018.
//

import Foundation

extension UUID {
    static func empty() -> UUID {
        return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    }
    
    func isEmpty() -> Bool {
        return self.uuidString == "00000000-0000-0000-0000-000000000000"
    }
}
