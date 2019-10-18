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
    
    // MARK: - Input
    
    let currencyAmount = BehaviorRelay<Double>(value: 0)
    let updateActiveCurrency: BehaviorRelay<CurrencyCellViewModel>
    
    // MARK: - Output
    
    lazy var activeCurrency: Observable<CurrencyCellViewModel> = {
        self.updateActiveCurrency
            .distinctUntilChanged()
            .map { [unowned self] in
                let model = RateModel(baseCurrency: $0.currencyCode, currency: $0.currencyCode, rate: 1)
                return CurrencyCellViewModel(withModel: model, amount: self.currencyAmount.asObservable())
            }
    }()
    
    let currencyRates = BehaviorRelay<[CurrencyCellViewModel]>(value: [])
    
    var hackCounter = 0
    
    private let disposeBag = DisposeBag()
    
    init() {
        let defaultCurrency = RateModel(baseCurrency: "EUR", currency: "EUR", rate: 1)
        updateActiveCurrency = BehaviorRelay<CurrencyCellViewModel>(value: CurrencyCellViewModel(withModel: defaultCurrency, amount: currencyAmount.asObservable()))
                
        let timer = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        Observable.combineLatest(timer, activeCurrency.distinctUntilChanged()) { _, currency -> Observable<[RateModel]> in
                return try RateService.getRates(currency: currency.currencyCode)
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { return $0 }
            .map { [unowned self] models in
                return models.map { CurrencyCellViewModel(withModel: $0, amount: self.currencyAmount.asObservable()) }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(currencyRates)
            .disposed(by: disposeBag)
    }

}
