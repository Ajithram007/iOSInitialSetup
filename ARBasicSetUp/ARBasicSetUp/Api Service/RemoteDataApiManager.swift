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

extension RemoteDataApiManager {
    static func fetchData<T: Decodable>(baseUrl: String = (DataStore.shared.configuration?.baseUrl ?? ""),
                                        endPoint: String = "",
                                        method: ServiceMethod = .GET,
                                        param: [String:Any]? = nil,
                                        completionWithSuccess: @escaping((T) -> ()),
                                        failure: @escaping((APIError) -> ())) {
        
        guard let url = URL(string: baseUrl + endPoint)  else { failure(.internalError); return }
       
        let request = NSMutableURLRequest(url: url, cachePolicy:.useProtocolCachePolicy, timeoutInterval: 120)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = Constants.URLHeaders.headers
        if let parameter = param {
            do {
                let decoded = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                request.httpBody = decoded
            }
            catch {
                failure(.internalError)
            }
        }
        
        session.loadData(with: request as URLRequest) { (data, response, error) in
            RemoteDataApiManager.storeCookie(response: response)
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                      error == nil
                    else { failure(.serverError); return }

                do {
                    guard let data = data else { failure(.serverError); return }

                    let object = try JSONDecoder().decode(T.self, from: data)
                    completionWithSuccess(object)
                } catch {
                    failure(.parsingError)
                }
            }
        }
    }
}

