//
//  ConfigurationManager.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 18.02.2018.
//

import Foundation
import Configuration

extension ConfigurationManager {

    public func build() -> Configuration {
        let configuration = Configuration(manager: self)
        return configuration
    }
}
