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
     If an array of Card contains cards with identical names, likely due to multiple printings, this function leaves only one version of that card. You will only have one "Scathe Zombies" instead of 5 "Scathe Zombie", the only difference between them being the set they were printed in.
     
     
     - parameter cards: [Card]
     - returns: [Card] consisting of Cards without duplicate names
 */

    public static func removeDuplicateCardsByName(_ cards: [Card]) -> [Card] {
        
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


final class Parser {
    
     func parseCards(json: JSONResults) -> [Card] {

        guard let cards = json["cards"] as? [[String:Any]] else {
            if Magic.enableLogging {
                print("Parser parseCards - unexpected json: returning empty array")
            }
            return [Card]()
        }
        
        var cardsArray = [Card]()
        
        for c in cards {
            
            var card = Card()
            
            if let name = c["name"] as? String {
                card.name = name
            }
            if let names = c["names"] as? [String] {
                card.names = names
            }
            if let manaCost = c["manaCost"] as? String {
                card.manaCost = manaCost
            }
            if let cmc = c["cmc"] as? Int {
                card.cmc = cmc
            }
            if let colors = c["colors"] as? [String] {
                card.colors = colors
            }
            if let colorIdentiy = c["colorIdentity"] as? [String] {
                card.colorIdentity = colorIdentiy
            }
            if let type = c["type"] as? String {
                card.type = type
            }
            if let supertypes = c["supertypes"] as? [String] {
                card.supertypes = supertypes
            }
            if let types = c["types"] as? [String] {
                card.types = types
            }
            if let subtypes = c["subtypes"] as? [String] {
                card.subtypes = subtypes
            }
            if let rarity = c["rarity"] as? String {
                card.rarity = rarity
            }
            if let set = c["set"] as? String {
                card.set = set
            }
            if let setName = c["setName"] as? String {
                card.setName = setName
            }
            if let text = c["text"] as? String {
                card.text = text
            }
            if let artist = c["artist"] as? String {
                card.artist = artist
            }
            if let number = c["number"] as? String {
                card.number = number
            }
            if let power = c["power"] as? String {
                card.power = power
            }
            if let toughness = c["toughness"] as? String {
                card.toughness = toughness
            }
            if let layout = c["layout"] as? String {
                card.layout = layout
            }
            if let multiverseid = c["multiverseid"] as? Int {
                card.multiverseid = multiverseid
            }
            if let imageUrl = c["imageUrl"] as? String {
                card.imageUrl = imageUrl
            }
            if let rulings = c["rulings"] as? [[String:String]] {
                card.rulings = rulings
            }
            if let foreignNames = c["foreignNames"] as? [[String:String]] {
                card.foreignNames = foreignNames
            }
            if let printings = c["printings"] as? [String] {
                card.printings = printings
            }
            if let originalText = c["originalText"] as? String {
                card.originalText = originalText
            }
            if let originalType = c["originalType"] as? String {
                card.originalType = originalType
            }
            if let id = c["id"] as? String {
                card.id = id
            }
            if let loyalty = c["loyalty"] as? Int {
                card.loyalty = loyalty
            }
            if let legalities = c["legalities"] as? [[String: String]] {
                for pair in legalities {
                    guard let format = pair["format"],
                        let legality = pair["legality"] else {
                            continue
                    }
                    card.legalities[format] = legality
                }
            }
            
            cardsArray.append(card)
           
        }
        
        if Magic.enableLogging {
            print("cards retreived: \(cardsArray.count)")
        }
        
        return cardsArray
    }
    
    
     func parseSets(json: JSONResults) -> [CardSet] {
        
        guard let cardSets = json["sets"] as? [[String:Any]] else {
            if Magic.enableLogging {
                print("Parser parseSets - unexpected json: returning empty array")
            }
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
        
        if Magic.enableLogging {
            print("sets retreived: \(sets.count)")
        }
        return sets
        
    }

}
