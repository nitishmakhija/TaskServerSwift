//
//  BaseEntity.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 24.02.2018.
//

import Foundation

public protocol EntityProtocol: class, Codable {
    var id: UUID { get set }
    var createDate: Date { get set }
}
