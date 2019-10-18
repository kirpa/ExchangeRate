//
//  CurrencyCellView.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyCellView: UITableViewCell, CurrencyView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var roundedBackground: UIView! {
        willSet { newValue.roundedCorners() }
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    func configure(viewModel: CurrencyCellViewModel) {
        label.text = String(format: "\(viewModel.currencyCode) = \(viewModel.baseCurrency) %.3f", viewModel.rate)
        viewModel.value
            .map { String(format: "1 \(viewModel.currencyCode) = %.2f", $0) }
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
