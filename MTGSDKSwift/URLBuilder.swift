//
//  URLBuilder.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 4/5/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

import Foundation

final class URLBuilder {
    static func buildURLWithParameters(_ parameters: [SearchParameter],
                                andConfig config: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = {
            if parameters is [CardSearchParameter] {
                return Constants.cardsEndpoint
            } else {
                return Constants.setsEndpoint
            }
        }()
        
        urlComponents.queryItems = buildQueryItemsFromParameters(parameters, config)
        
        debugPrint("MTGSDK URL: \(String(describing: urlComponents.url))\n")
        
        return urlComponents.url
    }
    
    private static func buildQueryItemsFromParameters(_ parameters: [SearchParameter],
                                               _ config: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        let pageSizeQuery = URLQueryItem(name: "pageSize", value: String(config.pageSize))
        let pageQuery = URLQueryItem(name: "page", value: String(config.pageTotal))
        queryItems.append(pageQuery)
        queryItems.append(pageSizeQuery)
        
        for parameter in parameters {
            let name = parameter.name
            let value = parameter.value
            let item = URLQueryItem(name: name, value: value)
            queryItems.append(item)
        }
        
        return queryItems
    }
}
