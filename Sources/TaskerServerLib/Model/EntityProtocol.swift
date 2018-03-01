//
//  BaseEntity.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol EntityProtocol : Codable {
    var id: UUID { get set }
}
