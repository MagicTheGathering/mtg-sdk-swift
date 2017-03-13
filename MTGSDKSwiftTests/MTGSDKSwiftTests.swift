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
        magic.fetchPageSize = "24"
        magic.fetchPageTotal = "1"
        Magic.enableLogging = false
        
        magic.fetchCards([param]) {
            cards, error in
            
            if let error = error {
                self.networkError = error
            }
            
            self.cards = cards
            
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
         image, error in
            
            self.image = image
            
            assert(self.image != nil)
            
        }
        
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
