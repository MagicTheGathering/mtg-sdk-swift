//
//  ViewController.swift
//  tvExample
//
//  Created by Eric Internicola on 10/6/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit
import MTGSDKSwift

class ViewController: UIViewController {

    let magic = Magic()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard NSClassFromString("XCTestCase") == nil else {
            return
        }

        let params: [CardSearchParameter] = [
            CardSearchParameter(parameterType: .colors, value: "black"),
            CardSearchParameter(parameterType: .type, value: "planeswalker"),
            CardSearchParameter(parameterType: .loyalty, value: "5"),
            CardSearchParameter(parameterType: .legality, value: "Banned")
        ]
        let config = MTGSearchConfiguration(pageSize: 60, pageTotal: 1)

        params.forEach { param in
            magic.fetchCards([param], configuration: config) { (result) in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)

                case .success(let cards):
                    print("CARDS COUNT (for param \(param.name)): \(cards.count)")
                    for c in cards {
                        print("Card: \(c) \n")
                    }
                }
            }
        }
    }
}
