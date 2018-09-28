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
//    var parameterType: ParameterType {
//        return .setting
//    }
}

//public enum ParameterType {
//    case card
//    case set
//    case setting
//}

//public class SearchSettingsParameter: SearchParameter {
//    public enum SearchSetting: String {
//        case pageSize
//        case pageTotal
//    }
//
//    override var parameterType: ParameterType {
//        return .setting
//    }
//
//    public init(setting: SearchSetting, value: String) {
//        super.init()
//        name = setting.rawValue
//        self.value = value
//    }
//}

public final class CardSearchParameter: SearchParameter {
    
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
        case legality
        case releaseDate

     //   case custom(String)
        
//        var rawValue: String {
//            switch self {
//            case .name:
//                return "name"
//            case .cmc:
//                return "cmc"
//            case .colors:
//                return "colors"
//            case .type:
//                return "type"
//            case .supertypes:
//                return "supertypes"
//            case .subtypes:
//                return "subtypes"
//            case .rarity:
//                return "rarity"
//            case .text:
//                return "text"
//            case .set:
//                return "set"
//            case .artist:
//                return "artist"
//            case .power:
//                return "power"
//            case .toughness:
//                return "toughness"
//            case .multiverseid:
//                return "multiverseid"
//            case .gameFormat:
//                return "gameFormat"
//            case .loyalty:
//                return "loyalty"
//            case .legalities:
//                return "legalities"
//            case .releaseDate:
//                return "releaseDate"
//            case .custom(let param):
//                return param
//            }
//        }
    }
    
//    override var parameterType: ParameterType {
//        return .card
//    }

    public init(parameterType: CardQueryParameterType, value: String) {
        super.init()
        self.name = parameterType.rawValue
        self.value = value
    }
}

public final class SetSearchParameter: SearchParameter {
    
    public enum SetQueryParameterType: String {
        case name
        case block
    }
//
//    override var parameterType: ParameterType {
//        return .set
//    }

    public init(parameterType: SetQueryParameterType, value: String) {
        super.init()
        self.name = parameterType.rawValue
        self.value = value
        
    }
}

//protocol Parameter {
//    var rawValue: String { get }
//    var parameterType: ParameterType { get }
//}
//
//enum CardSearchParameterX: String, Parameter {
//    //cards
//    case name
//    case cmc
//    case colors
//    case type
//    case supertypes
//    case subtypes
//    case rarity
//    case text
//    case set
//    case artist
//    case power
//    case toughness
//    case multiverseid
//    case gameFormat
//    case loyalty
//
//    var parameterType: ParameterType {
//        return .card
//    }
//
//}
//
//enum SetSearchParameterX: String, Parameter {
//    //sets
//    case name
//    case block
//
//    var parameterType: ParameterType {
//        return .set
//    }
//}
//
//enum Params {
//    case card
//    case set
//    case setting
//
//    enum Card {
//        case name
//    }
//    enum Set {
//        case name
//    }
//    enum Setting {
//        case pageSize
//    }
//}




//
