//
//  ActiveCurrencyCellView.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 09/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit

class ActiveCurrencyCellView: UITableViewCell, CurrencyView {
 
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textInput: UITextField!
    
    func configure(viewModel: CurrencyCellViewModel) {    
        label.text = viewModel.currencyCode
    }
    
}
