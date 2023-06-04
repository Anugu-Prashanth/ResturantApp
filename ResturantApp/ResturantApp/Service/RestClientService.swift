//
//  RestClientService.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import Foundation

import Foundation

class RestClientService {
    //Protocol created, Create Mock protocol for testing
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getData(urlRequest: URLRequest,
                 completionHandler: @escaping (Data?, Error?) -> ()) {
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            completionHandler(data, error)
        }.resume()
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
