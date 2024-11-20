//
//  MagicalCardManager.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/1/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final public class Magic {
    public typealias CardCompletion = (Result<[Card]>) -> Void
    public typealias SetCompletion = (Result<[CardSet]>) -> Void

    /// Should the Magic API log messages to the `print` function?  Defaults to true.
    public static var enableLogging = true

    private let mtgAPIService = MTGAPIService()
    
    /// Default initialization
    public init() { }

    /// Reteives an array of Cards which match the parameters given.
    /// See https://docs.magicthegathering.io/#api_v1cards_list for more info.
    ///
    /// - Parameters:
    ///   - parameters: The Card Search Parameters that you'd like to search with.
    ///   - configuration: The Search Configuration (defaults to `.defaultConfiguration`).
    ///   - completion: The completion handler (for success / failure response).
    public func fetchCards(_ parameters: [CardSearchParameter],
                           configuration: MTGSearchConfiguration = .defaultConfiguration,
                           completion: @escaping CardCompletion) {

        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            completion(Result.error(NetworkError.miscError("fetchCards url build failed")))
            return
        }
        
        mtgAPIService.mtgAPIQuery(url: url, responseObject: CardsResponse.self) {
            result in
            switch result {
            case .success(let results):
                completion(Result.success(results.cards))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    /// Retrieves an array of Cards which match the parameters given using Swift concurrency and utilizes `async await`.
    /// See https://docs.magicthegathering.io/#api_v1cards_list for more info.
    ///
    /// - Parameters:
    ///   - parameters: The Card Search Parameters that you'd like to search with.
    ///   - configuration: The Search Configuration (defaults to `.defaultConfiguration`).
    @available(iOS 15.0, *)
    public func fetchCards(_ parameters: [CardSearchParameter],
                           configuration: MTGSearchConfiguration = .defaultConfiguration) async throws -> [Card] {
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            throw NetworkError.miscError("fetchCards URL build failed")
        }
        
        return try await mtgAPIService.mtgAPIQuery(url: url, responseObject: CardsResponse.self).cards
    }
    
    /// Reteives an array of CardSet which matches the parameters given.
    /// See https://docs.magicthegathering.io/#api_v1sets_list for more info.
    ///
    /// - Parameters:
    ///   - parameters: The Card Set search parameters you want to search for.
    ///   - configuration: The Search Configuration, defaults to `.defaultConfiguration`.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchSets(_ parameters: [SetSearchParameter],
                          configuration: MTGSearchConfiguration = .defaultConfiguration,
                          completion: @escaping SetCompletion) {
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            return completion(Result.error(NetworkError.miscError("fetchSets url build failed")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url, responseObject: SetsResponse.self) {
            result in
            switch result {
            case .success(let setsResponse):
                completion(Result.success(setsResponse.sets))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }

    /// Fetch JSON returns the raw json data rather than an Array of Card or CardSet. It will return json
    /// for sets or cards depending on what you feed it.
    ///
    /// - Parameters:
    ///   - parameters: either [CardSearchParameter] or [SetSearchParameter]
    ///   - configuration: The Search Configuration, defaults to `.defaultConfiguration`.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchJSON(_ parameters: [SearchParameter],
                          configuration: MTGSearchConfiguration = .defaultConfiguration,
                          completion: @escaping (Result<JSONResults>) -> Void) {
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            completion(Result.error(NetworkError.miscError("fetchJSON url build failed")))
            return
        }
        
        mtgAPIService.jsonQuery(url: url) {
            result in
            switch result {
            case .success:
                completion(result)
            case .error(let error):
                completion(Result.error(NetworkError.requestError(error)))
                return
            }
        }
    }
    
#if canImport(UIKit)
    public typealias CardImageCompletion = (Result<UIImage>) -> Void
    
    /// Retreives a UIImage based on the imageURL of the Card passed in
    ///
    /// - Parameters:
    ///   - card: The card you wish to get the image for.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchImageForCard(_ card: Card, completion: @escaping CardImageCompletion) {
        guard let imgurl = card.imageUrl else {
            return completion(Result.error(NetworkError.fetchCardImageError("fetchImageForCard card imageURL was nil")))
        }
        
        guard let url = URL(string: imgurl) else {
            return completion(Result.error(NetworkError.fetchCardImageError("fetchImageForCard url build failed")))
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let img = UIImage(data: data) else {
                return completion(Result.error(NetworkError.fetchCardImageError("could not create uiimage from data")))
            }
            completion(Result.success(img))
        } catch {
            completion(Result.error(NetworkError.fetchCardImageError("data from contents of url failed")))
        }
    }
#endif
    
#if canImport(AppKit)
    public typealias CardImageCompletion = (Result<NSImage>) -> Void
    
    /// Retreives a NSImage based on the imageURL of the Card passed in
    ///
    /// - Parameters:
    ///   - card: The card you wish to get the image for.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchImageForCard(_ card: Card, completion: @escaping CardImageCompletion) {
        guard let imgurl = card.imageUrl else {
            return completion(Result.error(NetworkError.fetchCardImageError("fetchImageForCard card imageURL was nil")))
        }
        
        guard let url = URL(string: imgurl) else {
            return completion(Result.error(NetworkError.fetchCardImageError("fetchImageForCard url build failed")))
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let img = NSImage(data: data) else {
                return completion(Result.error(NetworkError.fetchCardImageError("could not create uiimage from data")))
            }
            completion(Result.success(img))
        } catch {
            completion(Result.error(NetworkError.fetchCardImageError("data from contents of url failed")))
        }
    }
#endif
    
    /// This function simulates opening a booster pack for the given set, producing an array of [Card]
    ///
    /// - Parameters:
    ///   - setCode: the set code of the desired set
    ///   - completion: The completion handler (for success / failure response).
    public func generateBoosterForSet(_ setCode: String, completion: @escaping CardCompletion) {
        let urlString = Constants.baseEndpoint + setCode + Constants.generateBoosterPath
        
        guard let url = URL(string: urlString) else {
            return completion(Result.error(NetworkError.miscError("generateBooster - build url fail")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url, responseObject: CardsResponse.self) {
            result in
            switch result {
            case .success(let results):
                completion(Result.success(results.cards))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
}

final public class ResultsFilter {
    
    /**
     If an array of Card contains cards with identical names, likely due to multiple printings, this function leaves only one version of that card. You will only have one "Scathe Zombie" instead of 5 "Scathe Zombie", the only difference between them being the set they were printed in.
     
     - parameter cards: [Card]
     - returns: [Card] consisting of Cards without duplicate names
     */
    
    static public func removeDuplicateCardsByName(_ cards: [Card]) -> [Card] {
        var uniqueNames = [String]()
        var uniqueCards = [Card]()
        
        for c in cards {
            if let name = c.name {
                if !uniqueNames.contains(name) {
                    uniqueCards.append(c)
                }
                uniqueNames.append(name)
            }
        }
        
        return uniqueCards
    }
}
