//
//  CurrencyCellViewModel.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

class CurrencyCellViewModel: Equatable {
    
    var currencyCode: String {
        model.currency
    }
    
    var baseCurrency: String {
        model.baseCurrency
    }
    
    var rate: Double {
        model.rate
    }
    
    fileprivate let model: RateModel
    
    init(withModel: RateModel) {
        model = withModel
    }
    
    static func ==(lhs: CurrencyCellViewModel, rhs: CurrencyCellViewModel) -> Bool {
        return lhs.model == rhs.model
    }

}
