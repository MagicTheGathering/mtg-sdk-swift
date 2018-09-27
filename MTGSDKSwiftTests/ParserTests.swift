//
//  ParserTests.swift
//  MTGSDKSwiftTests
//
//  Created by Eric Internicola on 9/26/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

@testable import MTGSDKSwift
import XCTest

class ParserTests: XCTestCase {

    let parser = Parser()
    var karn: Card? {
        guard let karn = readMapped(jsonfile: "karn.json") else {
            return nil
        }
        return parser.parseCards(json: karn).first
    }

    func testReadKarn() {
        if let name = karn?.name {
            XCTAssertEqual("Karn Liberated", name)
        } else {
            XCTFail("No card name")
        }
    }

    func testParseLoyalty() {
        XCTAssertEqual(6, karn?.loyalty)
    }

    func testParseLegalities() {
        XCTAssertEqual("Legal", karn?.legalities["Vintage"])
    }

    func testParseRulings() {
        guard let rulings = karn?.rulings else {
            return XCTFail("No rulings for Karn")
        }
        XCTAssertNotEqual(0, rulings.count)

    }

    func testParseName() {
        XCTAssertEqual("Karn Liberated", karn?.name)
    }

    func testParseManaCost() {
        XCTAssertEqual("{7}", karn?.manaCost)
    }

    func testParseCmc() {
        XCTAssertEqual(7, karn?.cmc)
    }

    func testParseType() {
        XCTAssertEqual("Legendary Planeswalker — Karn", karn?.type)
    }

    func testParseRarity() {
        XCTAssertEqual("Mythic Rare", karn?.rarity)
    }

    func testParseSet() {
        XCTAssertEqual("MM2", karn?.set)
    }

    func testParseSetName() {
        XCTAssertEqual("Modern Masters 2015 Edition", karn?.setName)
    }

    func testParseText() {
        XCTAssertEqual("+4: Target player exiles a card from their hand.\n−3: Exile target permanent.\n−14: Restart the game, leaving in exile all non-Aura permanent cards exiled with Karn Liberated. Then put those cards onto the battlefield under your control.", karn?.text)
    }

    func testParseArtist() {
        XCTAssertEqual("Jason Chan", karn?.artist)
    }

    func testParseNumber() {
        XCTAssertEqual("4", karn?.number)
    }

    func testParseLayout() {
        XCTAssertEqual("normal", karn?.layout)
    }

    func testParseMultiverseid() {
        XCTAssertEqual(397828, karn?.multiverseid)
    }

    func testParseSupertypes() {
        guard let supertypes = karn?.supertypes else {
            return XCTFail("Karn is missing the supertypes field")
        }
        XCTAssertTrue(supertypes.contains("Legendary"), "Karn is missing a supertypes value")
    }

    func testParseTypes() {
        guard let types = karn?.types else {
            return XCTFail("Karn is missing the types field")
        }
        XCTAssertTrue(types.contains("Planeswalker"), "Karn is missing a types value")
    }

    func testParseSubtypes() {
        guard let subtypes = karn?.subtypes else {
            return XCTFail("Karn is missing the subtypes field")
        }
        XCTAssertTrue(subtypes.contains("Karn"), "Karn is missing a subtypes value")
    }

    func testParseImageUrl() {
        XCTAssertEqual("http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=397828&type=card", karn?.imageUrl)
    }

    func testParseOriginalText() {
        XCTAssertEqual("+4: Target player exiles a card from his or her hand.\n−3: Exile target permanent.\n−14: Restart the game, leaving in exile all non-Aura permanent cards exiled with Karn Liberated. Then put those cards onto the battlefield under your control.", karn?.originalText)
    }

    func testParsePrintings() {
        guard let printings = karn?.printings else {
            return XCTFail("Karn is missing the printings field")
        }
        [ "NPH", "MM2" ].forEach {
            XCTAssertTrue(printings.contains($0), "printings is missing the value \($0)")
        }
    }

    func testParseOriginalType() {
        XCTAssertEqual("Planeswalker — Karn", karn?.originalType)
    }

    func testParseId() {
        XCTAssertEqual("6dbb000f1dffa20fbb9159b7ac36b814d209558c", karn?.id)
    }

}

// MARK: - Implementation

extension ParserTests {

    /// Reads the provided json file as a JSONResults (`[String: Any]`)
    ///
    /// - Parameter named: the name of the file to open.
    /// - Returns: the JSONResults object if possible.
    func readMapped(jsonfile named: String) -> JSONResults? {
        guard let data = read(jsonfile: named) else {
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONResults
        } catch {
            XCTFail("Failed to parse JSON: \(error.localizedDescription)")
            return nil
        }
    }

    /// Reads the provided json file to data.
    ///
    /// - Parameter named: the file name to read.
    /// - Returns: the data from the file or nil.
    func read(jsonfile named: String) -> Data? {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: named, ofType: nil) else {
            XCTFail("Failed to locate the file: \(named)")
            return nil
        }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch {
            XCTFail("Failed to read data from file \(filePath): \(error.localizedDescription)")
            return nil
        }
    }
}
