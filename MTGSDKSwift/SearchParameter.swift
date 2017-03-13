//
//  SearchParameter.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation


public class SearchParameter {
    public var name: String = ""
    public var value: String = ""
}


public class CardSearchParameter: SearchParameter {
    
    public enum CardQueryParameterType: String {
        case name
        case cmc
        case colors
        case type
        case supertypes
        case subtypes
        case rarity
        case text
        case set
        case artist
        case power
        case toughness
        case multiverseid
        case gameFormat
        
    }

    public init(parameterType: CardQueryParameterType, value: String) {
        super.init()
        self.name = parameterType.rawValue
        self.value = value
                
            }
    
}

public class SetSearchParameter: SearchParameter {
    
    public enum SetQueryParameterType: String {
        case name
        case block
    }

    public init(parameterType: SetQueryParameterType, value: String) {
        super.init()
        self.name = parameterType.rawValue
        self.value = value
        
    }
}





//
