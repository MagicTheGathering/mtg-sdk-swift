//
//  MTGSearchConfiguration.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 4/16/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

import Foundation

public struct MTGSearchConfiguration {
    public static var defaultConfiguration: MTGSearchConfiguration {
        return MTGSearchConfiguration(pageSize: Int(Constants.defaultPageSize) ?? 12,
                                      pageTotal: Int(Constants.defaultPageTotal) ?? 1)
    }
    
    public let pageSize: Int
    public let pageTotal: Int
    
    public init(pageSize: Int, pageTotal: Int) {
        self.pageSize = pageSize
        self.pageTotal = pageTotal
    }
}
