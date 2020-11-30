//
//  NetworkSessionMock.swift
//  ARBasicSetUpUITests
//
//  Created by Ajithram on 30/11/20.
//

import Foundation
@testable import ARBasicSetUp

class NetworkSessionMock : NetworkSession {
    
    var data : Data?
    var urlResponse : URLResponse?
    var error : Error?
    
    
    var urlRequest : URLRequest?
    var isfunctionCalled : Bool = false
    
    
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(self.data,self.urlResponse,self.error)
        isfunctionCalled = true
        self.urlRequest = urlRequest
    }
}
