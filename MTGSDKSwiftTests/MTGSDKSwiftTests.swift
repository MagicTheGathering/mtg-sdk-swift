//
//  MTGSDKSwiftTests.swift
//  MTGSDKSwiftTests
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import MTGSDKSwift
import XCTest

class MTGSDKSwiftTests: XCTestCase {
    
    var magic: Magic = Magic()
    
    override func setUp() {
        super.setUp()
    }
}

// MARK: - Card Search Tests

extension MTGSDKSwiftTests {

    func testCardSearchNoResults() {
        let param = CardSearchParameter(parameterType: .name, value: "abcdefghijk")
        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { (result) in
            defer {
                exp.fulfill()
            }

            switch result {
            case .success(let cards):
                XCTAssertTrue(cards.count == 0, "Results came back")
            case .error(let error):
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testCardSearchWithCards() {
        let param = CardSearchParameter(parameterType: .name, value: "lotus")
        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { (result) in
            defer {
                exp.fulfill()
            }
            
            switch result {
            case .success(let cards):
                XCTAssertTrue(cards.count > 0, "No card results came back")
            case .error(let error):
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Fetch Planeswalker

extension MTGSDKSwiftTests {

    func testFetchKarnAndVerify() {
        let cardName = "Karn Liberated"
        let param = CardSearchParameter(parameterType: .name, value: cardName)

        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { (result) in
            defer {
                exp.fulfill()
            }
            
            switch result {
            case .success(let cards):
                XCTAssertEqual(cardName, cards.first?.name)
                XCTAssertEqual(6, cards.first?.loyalty)
            case .error(let error):
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// MARK: - Fetch Image Tests

extension MTGSDKSwiftTests {
    func testFetchValidImage() {
        var card = Card()
        card.imageUrl = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=391870&type=card"

        let exp = expectation(description: "fetchImageForCard")

        magic.fetchImageForCard(card) { (result) in
            defer {
                exp.fulfill()
            }
            
            switch result {
            case .success:
                break
            case .error(let error):
                XCTFail("Error getting image: \(error.localizedDescription)")
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchImageError() {
        var card = Card()
        let exp = expectation(description: "fetchImageForCard")
        
        magic.fetchImageForCard(card) { (result) in
            defer {
                exp.fulfill()
            }
            
            switch result {
            case .success:
                XCTFail("Got an image back for a card without an image")
            case .error:
                break
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
