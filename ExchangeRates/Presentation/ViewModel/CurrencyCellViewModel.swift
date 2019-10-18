//
//  CurrencyCellViewModel.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import RxSwift
import RxCocoa

class CurrencyCellViewModel: Equatable {
    
    var currencyCode: String { model.currency }
    var baseCurrency: String { model.baseCurrency }
    var rate: Double { model.rate }
    var value: Driver<Double>
    var currencyName: String? { locale.localizedString(forCurrencyCode: model.currency) }
    
    fileprivate let model: RateModel
    fileprivate let locale = NSLocale.current
    fileprivate let disposeBag = DisposeBag()
    
    init(withModel: RateModel, amount: Observable<Double>) {
        model = withModel
        value = amount
            .asDriver(onErrorJustReturn: 1)
            .map { withModel.rate * $0 }
    }
    
    static func ==(lhs: CurrencyCellViewModel, rhs: CurrencyCellViewModel) -> Bool {
        return lhs.model == rhs.model
    }

}
