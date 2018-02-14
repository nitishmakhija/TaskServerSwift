//
//  Routes.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import PerfectHTTP

extension Routes {
    public mutating func configure(basedOnControllers controllers: [Controller]) {
        for controller in controllers {
            self.add(controller.routes)
        }
    }
}
