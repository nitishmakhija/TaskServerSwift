//
//  Routes.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP

extension Routes {
    
    public mutating func configure(allRoutes controllers: [Controller]) {
        for controller in controllers {
            self.add(controller.allRoutes)
        }
    }
    
    public mutating func configure(routesWithAuthorization controllers: [Controller]) {
        for controller in controllers {
            self.add(controller.routesWithAuthorization)
        }
    }
}
