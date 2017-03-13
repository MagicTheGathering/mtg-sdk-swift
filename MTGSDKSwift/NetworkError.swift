//
//  NetworkError.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/3/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case requestError(Error)
    case unexpectedHTTPResponse(HTTPURLResponse)
    case fetchCardImageError(String)
    case miscError(String)
}
