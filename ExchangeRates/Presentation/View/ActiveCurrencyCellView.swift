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
 
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var roundedBackground: UIView! {
        willSet { newValue.roundedCorners() }
    }
    
    fileprivate var disposeBag = DisposeBag()
    
    func configure(viewModel: CurrencyCellViewModel) {    
        codeLabel.text = viewModel.currencyCode
        nameLabel.text = viewModel.currencyName        
        viewModel.value
            .map { String(format: "%.3f", $0) }
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
