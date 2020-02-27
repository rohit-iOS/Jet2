//
//  APIManager.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import Foundation
import Reachability

class APIManager {
    
    private static func dataTask(requestUrlStr: String, method: String, completion: @escaping (_ success: Bool, _ object: Data?, _ offlineData:Bool) -> ()) {
        
        
        do {
            let reachability = try Reachability()
            if reachability.connection != .unavailable {
                let urlStr = UrlComponents.baseUrlStr + requestUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let request = NSMutableURLRequest(url: URL(string: urlStr)!)
                
                request.httpMethod = method
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    if let data = data {
                        completion(true, data, false)
                    }
                    else {
                        completion(false, nil, false)
                    }
                }.resume()
            } else {
                print("No network available")
                completion(false, nil, true)
            }
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    static func post(request: String, completion: @escaping (_ success: Bool, _ object: Data?, _ offline: Bool) -> ()) {
        dataTask(requestUrlStr: request, method: "POST", completion: completion)
    }
    
    static func put(request: String, completion: @escaping (_ success: Bool, _ object: Data?, _ offline: Bool) -> ()) {
        dataTask(requestUrlStr: request, method: "PUT", completion: completion)
    }
    
    static func get(request: String, completion: @escaping (_ success: Bool, _ object: Data?, _ offline: Bool) -> ()) {
        dataTask(requestUrlStr: request, method: "GET", completion: completion)
    }
}
