//
//  MTGAPIService.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public typealias JSONResults = [String:Any]
typealias JSONDataCompletion = (Result<(data: Data, json: JSONResults)>) -> Void

public enum Result<T> {
    case success(T)
    case error(NetworkError)
}

protocol ResponseObject: Decodable {}

final class MTGAPIService {

    /// Performs A query against the MTG APIs and calls back to the provided completion handler
    /// with a success or failure.
    ///
    /// - Parameters:
    ///   - url: The MTG URL to hit.
    ///   - completion: The completion handler block to handle the response.
    func mtgAPIQuery<T: ResponseObject>(url: URL, responseObject: T.Type, completion: @escaping (Result<T>) -> Void) {
        let networkOperation = NetworkOperation(url: url)
        networkOperation.performOperation {
            result in
            switch result {
            case .success(let json):
                do {
                    let result = try JSONDecoder().decode(T.self, from: json.data)
                    completion(Result.success(result))
                } catch {
                    completion(Result.error(NetworkError.decodableError(error)))
                }
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    @available(iOS 15.0, *)
    func mtgAPIQuery<T: ResponseObject>(url: URL, responseObject: T.Type) async throws -> T {
        let networkOperation = NetworkOperation(url: url)
        
        let responseData = try await networkOperation.performOperation()

        do {
            return try JSONDecoder().decode(T.self, from: responseData)
        } catch {
            throw NetworkError.decodableError(error)
        }
    }
    
    func jsonQuery(url: URL, completion: @escaping (Result<JSONResults>) -> Void) {
        let networkOperation = NetworkOperation(url: url)
        networkOperation.performOperation {
            result in
            switch result {
            case .success(let json):
                completion(Result.success(json.json))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
}

final private class NetworkOperation {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func performOperation(completion: @escaping JSONDataCompletion) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let error = error {
                return completion(Result.error(NetworkError.requestError(error)))
            }

            guard let data = data else {
                return completion(Result.error(NetworkError.miscError("Network operation - No data returned")))
            }

            if let httpResponse = (response as? HTTPURLResponse) {
                debugPrint("MTGSDK HTTPResponse - status code: \(httpResponse.statusCode)")
            
                switch httpResponse.statusCode {
                case 200..<300:
                    break
                default:
                    return completion(Result.error(NetworkError.unexpectedHTTPResponse(httpResponse)))
                }
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let json = jsonResponse as? JSONResults else {
                    return completion(Result.error(NetworkError.miscError("Network operation - invalid json response")))
                }
                completion(Result.success((data, json)))
            } catch {
                completion(Result.error(NetworkError.miscError("json serialization error")))
            }
        }.resume()
    }
    
    @available(iOS 15.0, *)
    func performOperation() async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard data.count > 0 else {
            throw NetworkError.miscError("Network operation - No data returned")
        }
        
        if let httpResponse = (response as? HTTPURLResponse) {
            debugPrint("MTGSDK HTTPResponse - status code: \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
            case 200..<300:
                break
            default:
                throw NetworkError.unexpectedHTTPResponse(httpResponse)
            }
        }
        
        return data
    }
}
