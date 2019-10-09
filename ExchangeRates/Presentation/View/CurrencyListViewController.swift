//
//  CurrencyListViewController.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 08/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CurrencyConverter.currencyName(code: "Waaagh!!")
        
    }


}

