//
//  MTGSDKSwiftTests.swift
//  MTGSDKSwiftTests
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import XCTest
@testable import MTGSDKSwift

class MTGSDKSwiftTests: XCTestCase {
    
    var cards: [Card]?
    var magic: Magic!
    let param = CardSearchParameter(parameterType: .name, value: "lotus")
    var networkError: NetworkError?
    var image: UIImage?
    
    override func setUp() {
        super.setUp()
       
        magic = Magic()

        magic.fetchCardsWithParameters([param]) { (result) in
            switch result {
            case .success(let cards):
                self.cards = cards
            case .error(let error):
                self.networkError = error
            }
        }
    }
    
    override func tearDown() {
        cards = nil
        magic = nil
        image = nil
        networkError = nil
        
        super.tearDown()
    }
    
    func testError() {
        assert(networkError != nil)
    }
    
    func testCards() {
        assert(cards != nil)
    }
    
    func testImage() {
        magic.fetchImageForCard(self.cards!.first!) {
            result in
            switch result {
            case .success(let image):
                self.image = image
            case .error(let error):
                print(error)
            }
            
            assert(self.image != nil)
        }
    }
}
