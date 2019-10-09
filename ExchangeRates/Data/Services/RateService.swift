//
//  RateService.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class RateService {
    
    private static let endpoint = "https://api.exchangeratesapi.io/latest?base="
    
    static func getRates(currency: String) throws -> Observable<[RateModel]> {
        guard let url = URL(string: endpoint + currency) else {
            throw ApiError.creatingURL(currency: currency)
        }
 
        return requestJSON(.get, url)
            .map { response, json in
                guard
                    let fullJSON = json as? [String: AnyObject],
                    let baseCurrency = fullJSON["base"] as? String,
                    let rates = fullJSON["rates"] as? [String: Double]
                    else { throw ApiError.parsingStructureError(response: json) }
                
                return rates.map { key, value in RateModel(baseCurrency: baseCurrency, currency: key, rate: value) }
        }
    }
    
}
