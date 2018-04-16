//
//  MTGAPIManager.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public typealias JSONResults = [String:Any]
public typealias JSONCompletionWithError = (Result<JSONResults>) -> Void

public enum Result<T> {
    case success(T)
    case error(NetworkError)
}

final class MTGAPIService {
    /**
     - parameter completion: (Result<JSONResults>) -> Void
     */
    func mtgAPIQuery(url: URL, completion: @escaping JSONCompletionWithError) {
        let networkOperation = NetworkOperation(url: url)
        networkOperation.performOperation {
            result in
            switch result {
            case .success(let json):
                completion(Result.success(json))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
}

final private class NetworkOperation {
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func performOperation(completion: @escaping JSONCompletionWithError) {
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }
        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                networkError = NetworkError.requestError(error!)
                return
            }
            guard data != nil else {
                networkError = NetworkError.miscError("Network operation - No data returned")
                return
            }

            if let httpResponse = (response as? HTTPURLResponse) {
                print("MTGSDK HTTPResponse - status code: \(httpResponse.statusCode)")
            
                switch httpResponse.statusCode {
                case 200..<300:
                    break
                default:
                    networkError = NetworkError.unexpectedHTTPResponse(httpResponse)
                    return
                }
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                if let json = jsonResponse as? JSONResults {
                    completion(Result.success(json))
                } else {
                    networkError = NetworkError.miscError("Network operation - invalid json response")
                }
            } catch {
                networkError = NetworkError.miscError("json serialization error")
                return
            }
        }
        
        dataTask.resume()
    }
}

