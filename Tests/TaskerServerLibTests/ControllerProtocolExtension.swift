//
//  ControllerProtocolExtension.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 30.03.2018.
//

import Foundation
import PerfectHTTP
@testable import TaskerServerLib

extension ControllerProtocol {

    func getAction(for actionType: ActionProtocol.Type) -> ActionProtocol? {

        for action in self.getActions() {

            if actionType == type(of: action) {
                return action
            }
        }

        return nil
    }
}
