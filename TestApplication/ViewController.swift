//
//  ViewController.swift
//  TestApplication
//
//  Created by Reed Carson on 3/14/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

import UIKit
import MTGSDKSwift

class ViewController: UIViewController {

    let magic = Magic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = CardSearchParameter(parameterType: .colors, value: "black")
        let type = CardSearchParameter(parameterType: .type, value: "planeswalker")
        let loyal = CardSearchParameter(parameterType: .loyalty, value: "5")
        let legal = CardSearchParameter(parameterType: .legality, value: "Banned")
        let config = MTGSearchConfiguration(pageSize: 60, pageTotal: 1)

        magic.fetchCards([color], configuration: config) { (result) in
            switch result {
            case .error(let error):
                print(error.localizedDescription)
            case .success(let cards):
                print("CARDS COUNT: \(cards.count)")
                for c in cards {
                    print("Card: \(c) \n")
                }
            }
        }
    }
}

