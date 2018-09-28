//
//  MagicalCardManager.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/1/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import UIKit

final public class Magic {
    public typealias CardImageCompletion = (Result<UIImage>) -> Void
    public typealias CardCompletion = (Result<[Card]>) -> Void
    public typealias SetCompletion = (Result<[CardSet]>) -> Void

    private let mtgAPIService: MTGAPIService
    
    public init() {
        self.mtgAPIService = MTGAPIService()
    }
    
    /**
     Reteives an array of Cards which match the parameters given
     - parameter parameters: [CardSearchParameter]
     - parameter configuration: MTGSearchConfiguration
     - parameter completion: (Result<[Card]>) -> Void
     */
    public func fetchCards(_ parameters: [CardSearchParameter],
                           _ configuration: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration,
                           _ completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            networkError = NetworkError.miscError("fetchCards url build failed")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            result in
            switch result {
            case .success(let json):
                let cards = Parser.parseCards(json: json)
                completion(Result.success(cards))
            case .error(let error):
                networkError = error
            }
        }
    }
    
    /**
     Reteives an array of CardSet which matches the parameters given
     - parameter parameters: [SetSearchParameter]
     - parameter configuration: MTGSearchConfiguration
     - parameter completion: (Result<[CardSet]>)-> Void
     */
    
    public func fetchSets(_ parameters: [SetSearchParameter],
                          _ configuration: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration,
                          _ completion: @escaping SetCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            networkError = NetworkError.miscError("fetchSets url build failed")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            result in
            switch result {
            case .success(let json):
                let sets = Parser.parseSets(json: json)
                completion(Result.success(sets))
            case .error(let error):
                networkError = error
            }
        }
    }
    
    /**
     Fetch JSON returns the raw json data rather than an Array of Card or CardSet. It will return json for sets or cards depending on what you feed it
     - parameter parameters: either [CardSearchParameter] or [SetSearchParameter]
     - parameter config: MTGSearchConfiguration
     - parameter completion: (Result<JSONResults>) -> Void
    */
    public func fetchJSON(_ parameters: [SearchParameter],
                          _ configuration: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration,
                          _ completion: @escaping JSONCompletionWithError) {
        
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            networkError = NetworkError.miscError("fetchJSON url build failed")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            result in
            switch result {
            case .success:
                completion(result)
            case .error(let error):
                networkError = NetworkError.requestError(error)
                return
            }
        }
    }
    
    
    /**
     Retreives a UIImage based on the imageURL of the Card passed in
     - parameter card: Card
     - parameter completion: (Result<UIImage>) -> Void
     */
    
    public func fetchImageForCard(_ card: Card,
                                  _ completion: @escaping CardImageCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }
        
        guard let imgurl = card.imageUrl else {
            networkError = NetworkError.fetchCardImageError("fetchImageForCard card imageURL was nil")
            return
        }
        
        guard let url = URL(string: imgurl) else {
            networkError = NetworkError.fetchCardImageError("fetchImageForCard url build failed")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let img = UIImage(data: data) else {
                networkError = NetworkError.fetchCardImageError("could not create uiimage from data")
                return
            }
            completion(Result.success(img))
        } catch {
            networkError = NetworkError.fetchCardImageError("data from contents of url failed")
        }
        
    }
    
    /**
     This function simulates opening a booster pack for the given set, producing an array of [Card]
     - parameter setCode: String: the set code of the desired set
     - parameter completion: (Result<[Card]>) -> Void
    */
    public func generateBoosterForSet(_ setCode: String,
                                      _ completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(Result.error(networkError!))
            }
        }

        let urlString = Constants.baseEndpoint + setCode + Constants.generateBoosterPath
        
        guard let url = URL(string: urlString) else {
            networkError = NetworkError.miscError("generateBooster - build url fail")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            result in
            switch result {
            case .success(let json):
                let cards = Parser.parseCards(json: json)
                completion(Result.success(cards))
            case .error(let error):
                networkError = error
            }
        }
    }
}
