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
    var parameterType: ParameterType {
        return .setting
    }
}


public enum ParameterType {
    case card
    case set
    case setting
}


public class SearchSettingsParameter: SearchParameter {
    public enum SearchSetting: String {
        case pageSize
        case pageTotal
    }
    
    override var parameterType: ParameterType {
        return .setting
    }
    
    public init(setting: SearchSetting, value: String) {
        super.init()
        name = setting.rawValue
        self.value = value
    }
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
        case loyalty
        case legalities
    }
    
    override var parameterType: ParameterType {
        return .card
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
    
    override var parameterType: ParameterType {
        return .set
    }

    public init(parameterType: SetQueryParameterType, value: String) {
        super.init()
        self.name = parameterType.rawValue
        self.value = value
        
    }
}

protocol Parameter {
    var rawValue: String { get }
    var parameterType: ParameterType { get }
}

enum CardSearchParameterX: String, Parameter {
    //cards
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
    case loyalty
    
    var parameterType: ParameterType {
        return .card
    }
 
}

enum SetSearchParameterX: String, Parameter {
    //sets
    case name
    case block
    
    var parameterType: ParameterType {
        return .set
    }
}

enum Params {
    case card
    case set
    case setting
    
    enum Card {
        case name
    }
    enum Set {
        case name
    }
    enum Setting {
        case pageSize
    }
}




//
