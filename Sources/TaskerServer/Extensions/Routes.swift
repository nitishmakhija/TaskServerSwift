//
//  Routes.swift
//  TaskerServer
//
//  Created by Marcin Czachurski on 13.02.2018.
//

import Foundation
import Dip
import PerfectHTTP

extension Routes {
    func configure(basedOnControllers controllers: [Controller]) {
        for controller in controllers {
            routes.add(controller.routes)
        }
    }
}
