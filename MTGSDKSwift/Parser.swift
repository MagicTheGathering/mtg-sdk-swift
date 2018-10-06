//
//  Parser.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

final class ResultsFilter {
    
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

public final class Parser {
    
     public static func parseCards(json: JSONResults) -> [Card] {

        guard let cards = json[JsonKeys.cards] as? [[String: Any]] else {
            debugPrint("MTGSDK Parser parseCards - unexpected json: returning empty array")
            return [Card]()
        }
        
        var cardsArray = [Card]()
        
        for c in cards {
            
            var card = Card()
            
            if let name = c[JsonKeys.name] as? String {
                card.name = name
            }
            if let names = c[JsonKeys.names] as? [String] {
                card.names = names
            }
            if let manaCost = c[JsonKeys.manaCost] as? String {
                card.manaCost = manaCost
            }
            if let cmc = c[JsonKeys.cmc] as? Int {
                card.cmc = cmc
            }
            if let colors = c[JsonKeys.colors] as? [String] {
                card.colors = colors
            }
            if let colorIdentiy = c[JsonKeys.colorIdentity] as? [String] {
                card.colorIdentity = colorIdentiy
            }
            if let type = c[JsonKeys.type] as? String {
                card.type = type
            }
            if let supertypes = c[JsonKeys.supertypes] as? [String] {
                card.supertypes = supertypes
            }
            if let types = c[JsonKeys.types] as? [String] {
                card.types = types
            }
            if let subtypes = c[JsonKeys.subtypes] as? [String] {
                card.subtypes = subtypes
            }
            if let rarity = c[JsonKeys.rarity] as? String {
                card.rarity = rarity
            }
            if let set = c[JsonKeys.set] as? String {
                card.set = set
            }
            if let setName = c[JsonKeys.setName] as? String {
                card.setName = setName
            }
            if let text = c[JsonKeys.text] as? String {
                card.text = text
            }
            if let artist = c[JsonKeys.artist] as? String {
                card.artist = artist
            }
            if let number = c[JsonKeys.number] as? String {
                card.number = number
            }
            if let power = c[JsonKeys.power] as? String {
                card.power = power
            }
            if let toughness = c[JsonKeys.toughness] as? String {
                card.toughness = toughness
            }
            if let layout = c[JsonKeys.layout] as? String {
                card.layout = layout
            }
            if let multiverseid = c[JsonKeys.multiverseid] as? Int {
                card.multiverseid = multiverseid
            }
            if let imageUrl = c[JsonKeys.imageUrl] as? String {
                card.imageUrl = imageUrl
            }
            if let rulings = c[JsonKeys.rulings] as? [[String:String]] {
                card.rulings = rulings
            }
            if let foreignNames = c[JsonKeys.foreignNames] as? [[String:String]] {
                card.foreignNames = foreignNames
            }
            if let printings = c[JsonKeys.printings] as? [String] {
                card.printings = printings
            }
            if let originalText = c[JsonKeys.originalText] as? String {
                card.originalText = originalText
            }
            if let originalType = c[JsonKeys.originalType] as? String {
                card.originalType = originalType
            }
            if let id = c[JsonKeys.id] as? String {
                card.id = id
            }
            if let loyalty = c[JsonKeys.loyalty] as? Int {
                card.loyalty = loyalty
            }
            if let format = c[JsonKeys.gameFormat] as? String {
                card.gameFormat = format
            }

            if let releaseDate = c[JsonKeys.releaseDate] as? String {
                card.releaseDate = releaseDate
            }
            if let legalities = c[JsonKeys.legalities] as? [[String: String]] {
                for pair in legalities {
                    guard let format = pair[JsonKeys.legalityFormat],
                        let legality = pair[JsonKeys.legalityLegality] else {
                            continue
                    }
                    card.legalities[format] = legality
                }
            }

            cardsArray.append(card)
           
        }
        
        debugPrint("MTGSDK cards retreived: \(cardsArray.count)")
        return cardsArray
    }
    
     static func parseSets(json: JSONResults) -> [CardSet] {
        
        guard let cardSets = json["sets"] as? [[String:Any]] else {
            debugPrint("MTGSDK Parser parseSets - unexpected json: returning empty array")
            return [CardSet]()
        }
        
        var sets = [CardSet]()
        
        for s in cardSets {
            var set = CardSet()
            
            if let name = s["name"] as? String {
                set.name = name
            }
            if let code = s["code"] as? String {
                set.code = code
            }
            if let block = s["block"] as? String {
                set.block = block
            }
            if let type = s["type"] as? String {
                set.type = type
            }
            if let border = s["border"] as? String {
                set.border = border
            }
            if let releaseDate = s["releaseDate"] as? String {
                set.releaseDate = releaseDate
            }
            if let magicCardsInfoCode = s["magicCardsInfoCode"] as? String {
                set.magicCardsInfoCode = magicCardsInfoCode
            }
            if let booster = s["booster"] as? [[String]] {
                set.booster = booster
            }
            
            sets.append(set)
        }
        
        debugPrint("MTGSDK sets retreived: \(sets.count)")
        
        return sets
    }
}

// MARK: - Keys

extension Parser {

    public struct JsonKeys {
        public static let cards = "cards"

        public static let name = "name"
        public static let names = "names"
        public static let manaCost = "manaCost"
        public static let cmc = "cmc"
        public static let colors = "colors"
        public static let colorIdentity = "colorIdentity"
        public static let type = "type"
        public static let supertypes = "supertypes"
        public static let types = "types"
        public static let subtypes = "subtypes"
        public static let rarity = "rarity"
        public static let set = "set"
        public static let setName = "setName"
        public static let text = "text"
        public static let artist = "artist"
        public static let number = "number"
        public static let power = "power"
        public static let toughness = "toughness"
        public static let layout = "layout"
        public static let multiverseid = "multiverseid"
        public static let imageUrl = "imageUrl"
        public static let rulings = "rulings"
        public static let foreignNames = "foreignNames"
        public static let printings = "printings"
        public static let originalText = "originalText"
        public static let originalType = "originalType"
        public static let id = "id"
        public static let loyalty = "loyalty"
        public static let gameFormat = "gameFormat"
        public static let releaseDate = "releaseDate"
        public static let legalities = "legalities"
        public static let legalityFormat = "format"
        public static let legalityLegality = "legality"
    }

}
