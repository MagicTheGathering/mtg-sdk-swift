//
//  Constants.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 4/16/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

import Foundation

struct Constants {
    static let baseEndpoint = "https://api.magicthegathering.io/v1"
    static let generateBoosterPath = "/booster"
    static let cardsEndpoint = "/v1/cards"
    static let setsEndpoint = "/v1/sets"
    static let host = "api.magicthegathering.io"
    static let scheme = "https"
    static let defaultPageSize = "12"
    static let defaultPageTotal = "1"
}

/// If logging is enabled, this function performs debug logging to the console for you with the
/// context of where it came from.
/// ## Example
/// ```
/// [MTGAPIService.swift:67:performOperation(completion:)]: MTGSDK HTTPResponse - status code: 200
/// ```
///
/// - Parameters:
///   - message: The message you'd like logged.
///   - file: The message source code file.
///   - function: The message source function.
///   - line: The message source line.
func debugPrint(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
    guard Magic.enableLogging else {
        return
    }
    print("[\((file as NSString).lastPathComponent):\(line):\(function)]: \(message)")
}
