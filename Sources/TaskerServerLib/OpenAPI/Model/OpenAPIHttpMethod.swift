//
//  OpenAPIHttpMethod.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 22.03.2018.
//

import Foundation

public enum OpenAPIHttpMethod {
    case options
    case get
    case head
    case post
    case patch
    case put
    case delete
    case trace
    case connect

    public static var allMethods: [OpenAPIHttpMethod] {
        return [.options, .get, .head, .post, .patch, .put, .delete, .trace, .connect]
    }
}
