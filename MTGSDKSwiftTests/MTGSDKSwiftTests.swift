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
                XCTAssertTrue(cards.count == 0)
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
                XCTAssertTrue(cards.count > 0)
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
        let param = CardSearchParameter(parameterType: .name, value: "Karn Liberated")

        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { (result) in
            defer {
                exp.fulfill()
            }
            
            switch result {
            case .success(let cards):
                guard let card = cards.first(where: {$0.id == "fc5dff7e-489f-5a42-bf3f-926985aaef4a" }) else {
                    XCTFail("unable to fetch expected test card")
                    return
                }
                XCTAssertEqual("Karn Liberated", card.name)
                XCTAssertEqual("6", cards.first?.loyalty)
                XCTAssertEqual("{7}", card.manaCost)
                XCTAssertEqual(7, card.cmc)
                XCTAssertEqual(nil, card.colors)
                XCTAssertEqual(nil, card.colorIdentity)
                XCTAssertEqual("Legendary Planeswalker — Karn", card.type)
                XCTAssertEqual(["Legendary"], card.supertypes)
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
        let card = Card()
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
