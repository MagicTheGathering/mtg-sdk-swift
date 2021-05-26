//
//  CardSet.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public struct CardSet: Decodable {
    public init() {}
    
    public var code: String?
    public var name: String?
    public var block: String?
    public var type: String?
    public var border: String?
    public var releaseDate: String?
    public var magicCardsInfoCode: String?
    public var booster: [[String]]?
}

public struct SetsResponse: ResponseObject, Decodable {
    public var sets: [CardSet]
}
