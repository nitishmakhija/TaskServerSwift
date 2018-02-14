//
//  FakeHTTPResponse.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectNet

class FakeHTTPResponse : HTTPResponse {

    var request: HTTPRequest = FakeHTTPRequest()
    var status: HTTPResponseStatus = HTTPResponseStatus.notImplemented
    var isStreaming: Bool = false
    var bodyBytes: [UInt8] = []
    var headers: AnyIterator<(HTTPResponseHeader.Name, String)>
    
    var body:String? {
        get {
            if self.bodyBytes.count != 0 {
                return String(bytes: self.bodyBytes, encoding: .utf8)
            }
            
            return nil
        }
    }
    
    init() {
        let emptyHeaders:[(HTTPResponseHeader.Name, String)] = []
        self.headers = AnyIterator(emptyHeaders.makeIterator())
    }
    
    func header(_ named: HTTPResponseHeader.Name) -> String? {
        return ""
    }
    
    func addHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        return self
    }
    
    func setHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        return self
    }
    
    func push(callback: @escaping (Bool) -> ()) {
    }
    
    func completed() {
    }
    
    func next() {
    }
}
