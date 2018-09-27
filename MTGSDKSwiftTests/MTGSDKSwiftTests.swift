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
    
    var magic: Magic = {
        let magic = Magic()
        magic.fetchPageSize = "24"
        magic.fetchPageTotal = "1"
        return magic
    }()
    
    override func setUp() {
        super.setUp()
        Magic.enableLogging = true
    }

}

// MARK: - Card Search Tests

extension MTGSDKSwiftTests {

    func testCardSearchNoResults() {
        let param = CardSearchParameter(parameterType: .name, value: "abcdefghijk")

        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { cards, error in

            defer {
                exp.fulfill()
            }

            if let error = error {
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }

            guard let cards = cards else {
                return XCTFail("No cards came back (nil cards)")
            }

            XCTAssertTrue(cards.count == 0, "Results came back")
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testCardSearchWithCards() {
        let param = CardSearchParameter(parameterType: .name, value: "lotus")

        let exp = expectation(description: "fetchCards")

        magic.fetchCards([param]) { cards, error in

            defer {
                exp.fulfill()
            }

            if let error = error {
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }

            guard let cards = cards else {
                return XCTFail("No cards came back (nil cards)")
            }

            XCTAssertTrue(cards.count > 0, "No card results came back")
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

        magic.fetchCards([param]) { cards, error in
            defer {
                exp.fulfill()
            }

            if let error = error {
                XCTFail("Error fetching cards: \(error.localizedDescription)")
            }

            guard let cards = cards, let first = cards.first else {
                return XCTFail("No cards came back (nil cards)")
            }

            if let firstName = first.name {
                XCTAssertEqual(cardName, firstName)
            } else {
                XCTFail("Card without a name")
            }
            XCTAssertEqual(6, first.loyalty)
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

        magic.fetchImageForCard(card) {
         image, error in
            defer {
                exp.fulfill()
            }
            if let error = error {
                XCTFail("Error getting image: \(error.localizedDescription)")
            }

            guard let image = image else {
                return XCTFail("Failed to get image for card")
            }
            XCTAssertNotNil(image)
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchImageError() {
        var card = Card()
        let exp = expectation(description: "fetchImageForCard")

        magic.fetchImageForCard(card) {
            image, error in
            defer {
                exp.fulfill()
            }

            if image != nil {
                XCTFail("Got an image back for a card without an image")
            }

            guard let error = error else {
                return XCTFail("No error came back for invalid card image")
            }

            XCTAssertNotNil(error)
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

}
