//
//  MTGAPIManager.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public struct MTGSearchConfiguration {
    static var defaultConfiguration: MTGSearchConfiguration {
        return MTGSearchConfiguration(pageSize: Int(Constants.defaultPageSize) ?? 12,
                                      pageTotal: Int(Constants.defaultPageTotal) ?? 1)
    }
    
    let pageSize: Int
    let pageTotal: Int
    
    public init(pageSize: Int, pageTotal: Int) {
        self.pageSize = pageSize
        self.pageTotal = pageTotal
    }
}

public typealias JSONResults = [String:Any]
public typealias JSONCompletionWithError = (Result<JSONResults>) -> Void

public enum Result<T> {
    case success(T)
    case error(NetworkError)
}

struct Constants {
    static let baseEndpoint = "https://api.magicthegathering.io/v1"
    static let generateBoosterPath = "/booster"
    static let host = "api.magicthegathering.io"
    static let scheme = "https"
    
    static let defaultPageSize = "6"
    static let defaultPageTotal = "1"
    
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

final class NetworkOperation {
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func performOperation(completion: @escaping JSONCompletionWithError) {
        
        if Magic.enableLogging {
            print("NetworkOperation - beginning performOperation... \n")
        }
        
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
                if Magic.enableLogging {
                    print("HTTPResponse - status code: \(httpResponse.statusCode)")
                }
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

