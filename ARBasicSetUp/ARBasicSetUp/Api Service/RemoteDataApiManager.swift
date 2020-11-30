//
//  RemoteDataApiManager.swift
//  ARBasicSetUp
//
//  Created by Ajithram on 30/11/20.
//

import Foundation

enum ServiceMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol NetworkSession {
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession : NetworkSession {
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: urlRequest) { (data, urlResponse, error) in
            completionHandler(data,urlResponse,error)
        }
        task.resume()
    }
}

@objcMembers
class RemoteDataApiManager: NSObject {
    
    static var session : NetworkSession = URLSession.shared
    
    static func createURLRequest(baseUrl: String = "", url: String = "", method: ServiceMethod = .GET,param:[String:Any]?) -> URLRequest? {
        
        if let url = URL(string: baseUrl + url) {
            let request = NSMutableURLRequest(url: url, cachePolicy:.useProtocolCachePolicy, timeoutInterval: 120)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = ["Authorization" : "authString"]
            if let parameter = param {
                do {
                    let decoded = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                    request.httpBody = decoded
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            return request as URLRequest
        }
        return nil
    }
    
    static func dataApiServiceCall(baseUrl: String = ("DomainName"),
                                   endPoint: String = "Endpoint",
                                   method: ServiceMethod = .GET,
                                   param: [String:Any]? = nil,
                                   completionWithSuccess: @escaping ((Data) -> ()) = { _ in },
                                   failure: @escaping ((Error?)->()) = { _ in }) {
        if let urlRequest = RemoteDataApiManager.createURLRequest(baseUrl: baseUrl, url: endPoint, method: method, param: param) {
            
            session.loadData(with: urlRequest) { (data, response, error) in
                if (data != nil && response != nil) {
                    DispatchQueue.main.async {
                        completionWithSuccess(data ?? Data())
                    }
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
        }
    }
    
}
