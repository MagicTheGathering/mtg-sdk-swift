//
//  Card.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

//TODO - Implement extra card properties

public struct Card: Equatable {
    
    public init() {}
    
    public var name: String?
    public var names: [String]?
    public var manaCost: String?
    public var cmc: Int?
    public var colors: [String]?
    public var colorIdentity: [String]?
    public var type: String?
    public var supertypes: [String]?
    public var types: [String]?
    public var subtypes: [String]?
    public var rarity: String?
    public var set: String?
    public var setName: String?
    public var text: String?
    public var artist: String?
    public var number: String?
    public var power: String?
    public var toughness: String?
    public var layout: String?
    public var multiverseid: Int?
    public var imageUrl: String?
    public var rulings: [[String:String]]?
    public var foreignNames: [[String:String]]?
    public var printings: [String]?
    public var originalText: String?
    public var originalType: String?
    public var id: String?
    public var flavor: String?
    public var loyalty: Int?
    public var legalities = [String: String]()
    
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id 
    }
    
    /*
    public var watermark: Any?
    public var reserved: Any?
    public var gameFormat: Any?
    public var variations: Any?
    public var releaseDate: Any?
 
 */
    

}
