//
//  MagicalCardManager.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/1/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import UIKit


final public class Magic {
    public init() {}

    public typealias CardImageCompletion = (UIImage?, NetworkError?) -> Void
    public typealias CardCompletion = ([Card]?, NetworkError?) -> Void
    public typealias SetCompletion = ([CardSet]?, NetworkError?) -> Void
    
    public static var enableLogging: Bool = false
    public var fetchPageSize: String = "12"
    public var fetchPageTotal: String = "1"
    
    private let mtgAPIService = MTGAPIService()
    private var urlManager: URLManager {
        let urlMan = URLManager()
        urlMan.pageTotal = fetchPageTotal
        urlMan.pageSize = fetchPageSize
        return urlMan
    }
    private let parser = Parser()
    
    /**
     Fetch JSON returns the raw json data rather than an Array of Card or CardSet. It will return json for sets or cards depending on what you feed it
     
     
     - parameter parameters: either [CardSearchParameter] or [SetSearchParameter]
      - parameter completion: ([String:Any]?, NetworkError?) -> Void
     
    */
    public func fetchJSON(_ parameters: [SearchParameter], completion: @escaping JSONCompletionWithError) {
        
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        guard let url = urlManager.buildURL(parameters: parameters) else {
            networkError = NetworkError.miscError("fetchJSON url build failed")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            json, error in
            if let error = error {
                networkError = NetworkError.requestError(error)
                return
            }
            completion(json, nil)
        }
        
    }
    
    
    /**
     Retreives a UIImage based on the imageURL of the Card passed in
     
     
     - parameter card: Card
     - parameter completion: (UIImage?, NetworkError?) -> Void
     
     */
    
    
    public func fetchImageForCard(_ card: Card, completion: @escaping CardImageCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
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
            if let img = UIImage(data: data) {
                completion(img, nil)
            } else {
                networkError = NetworkError.fetchCardImageError("could not create uiimage from data")
            }
            
        } catch {
            networkError = NetworkError.fetchCardImageError("data from contents of url failed")
        }
        
    }
    /**
     Reteives an array of CardSet which matches the parameters given
     
     - parameter parameters: [SetSearchParameter]
     - parameter completion: ([CardSet]?, NetworkError?) -> Void
     
     
    */
    
    public func fetchSets(_ parameters: [SetSearchParameter], completion: @escaping SetCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        if let url = urlManager.buildURL(parameters: parameters) {
            mtgAPIService.mtgAPIQuery(url: url) {
                json, error in
                if error != nil {
                    networkError = error
                    return
                }
                let sets = self.parser.parseSets(json: json!)
                completion(sets, nil)
            }
        } else {
            networkError = NetworkError.miscError("fetchSets url build failed")
        }
        
    }
    
    /**
     Reteives an array of Cards which match the parameters given
     
     - parameter parameters: [CardSearchParameter]
     - parameter completion: ([Card]?, NetworkError?) -> Void
     
     
     */
    
    public func fetchCards(_ parameters: [CardSearchParameter], completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        if let url = urlManager.buildURL(parameters: parameters) {
            mtgAPIService.mtgAPIQuery(url: url) {
                json, error in
                if error != nil {
                    networkError = error
                    return
                }
                let cards = self.parser.parseCards(json: json!)
                completion(cards, nil)
            }
        } else {
            networkError = NetworkError.miscError("fetchCards url build failed")
        }
        
    }
    
    /**
     This function simulates opening a booster pack for the given set, producing an array of [Card]
     
     - parameter setCode: String: the set code of the desired set
     - parameter completion: ([Card]?, NetworkError?) -> Void
 
    */
    
    public func generateBoosterForSet(_ setCode: String, completion: @escaping CardCompletion) {
        var networkError: NetworkError? {
            didSet {
                completion(nil, networkError)
            }
        }
        
        let endpoint = "https://api.magicthegathering.io/v1/sets/"
        let fullURLString = endpoint + setCode + "/booster"
        
        guard let url = URL(string: fullURLString) else {
            networkError = NetworkError.miscError("generateBooster - build url fail")
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url) {
            json, error in
            
            if let error = error {
                networkError = error
                return
            }
            
            let cards = self.parser.parseCards(json: json!)
            completion(cards, nil)
            
        }
        
    }
    
}
