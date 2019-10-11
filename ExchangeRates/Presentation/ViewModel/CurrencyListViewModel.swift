//
//  CurrencyListViewModel.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import RxSwift
import RxCocoa

class CurrencyListViewModel {
    
    let activeCurrency: BehaviorRelay<CurrencyCellViewModel>
    let currencyRates = BehaviorRelay<[CurrencyCellViewModel]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        let defaultCurrency = RateModel(baseCurrency: "EUR", currency: "EUR", rate: 1)
        activeCurrency = BehaviorRelay<CurrencyCellViewModel>(value: CurrencyCellViewModel(withModel: defaultCurrency))
                
        let timer = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        Observable.combineLatest(timer, activeCurrency.distinctUntilChanged()) { _, currency -> Observable<[RateModel]> in
            return try RateService.getRates(currency: currency.currencyCode)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .flatMapLatest { return $0 }
        .map { models in
            return models.map { CurrencyCellViewModel(withModel: $0) }
        }
        .asDriver(onErrorJustReturn: [])
        .drive(currencyRates)
        .disposed(by: disposeBag)
    }

}
