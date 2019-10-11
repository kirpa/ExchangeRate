//
//  CurrencyCellView.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit

class CurrencyCellView: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    func configure(viewModel: CurrencyCellViewModel) {
        label.text = String(format: "\(viewModel.currencyCode) = \(viewModel.baseCurrency) %.3f", viewModel.rate)
    }
    
}
