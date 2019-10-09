//
//  Errors.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case creatingURL(currency: String)
    case parsingStructureError(response: Any)    
}
