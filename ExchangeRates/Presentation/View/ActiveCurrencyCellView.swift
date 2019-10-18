//
//  ActiveCurrencyCellView.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActiveCurrencyCellView: UITableViewCell, CurrencyView {
 
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var roundedBackground: UIView! {
        willSet { newValue.roundedCorners() }
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    func configure(viewModel: CurrencyCellViewModel) {    
        currencyCodeLabel.text = viewModel.currencyCode
        viewModel.value
        .map { String(format: "%.2f", $0) }
        .drive(currencyValueLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
}
