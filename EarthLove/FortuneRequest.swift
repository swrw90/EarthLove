//
//  FortuneRequest.swift
//  EarthLove
//
//  Created by Seth Watson on 3/12/19.
//  Copyright © 2019 Yuusuke Hozumi and Seth Watson. All rights reserved.
//

import UIKit

var total: Int = 544

typealias FortuneJSON = [String: Any]

// Anonymous func that executes when completion is called, values returned by comnpletion are used as getFortune parameters.
typealias NetworkCompletion = (_ fortuneString: String?, _ error: Error?) -> Void

// Network class for requesting Fortune data from api.
class FortuneRequest {
    // Static method
    class func getFortune(completion: @escaping NetworkCompletion = {_, _ in }) -> URLSessionDataTask? {
        
        // URL configured to skip a random number of objects and limited to return 1 objects selected at random.
        guard let url = URL(string: "http://fortunecookieapi.herokuapp.com/v1/fortunes?limit=1&skip=\(Int.random(in: 0..<total))") else { return nil }
        
        // After data task execution completes the closure will parse the data or handle errors.
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []), let unwrappedJSON = json as? [FortuneJSON] else {
                completion(nil, error)
                return
            }
            // Network Completion is passed the Fortune message from the unwrapped JSON and error is nil.
            completion(unwrappedJSON.first?["message"] as? String, nil)
            print(unwrappedJSON.first?["message"])
        }
        
        // Starts the dataTask.
        dataTask.resume()
        return dataTask
    }
}
