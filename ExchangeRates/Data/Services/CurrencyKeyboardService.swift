//
//  KeyboardService.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 13/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit
import RxCocoa

class CurrencyKeyboardService: UIControl, UIKeyInput {

    let currentText = BehaviorRelay<String>(value: "")
    
    fileprivate let decimalDelimiter = NSLocale.current.decimalSeparator ?? "."
    
    
    // MARK: - UIKeyInput and UIControl variable overrides
    
    var keyboardType: UIKeyboardType = .decimalPad
    override var canBecomeFirstResponder: Bool { true }
    var hasText: Bool {
        currentText.value.count > 0
    }
    
    
    // MARK: - Implementation
    
    func resetText() {
        currentText.accept("0")
    }
    
    
    // MARK: - UIKeyInput implementation

    func insertText(_ text: String) {
        if !text.contains(decimalDelimiter) || !currentText.value.contains(decimalDelimiter) {
            currentText.accept(currentText.value + text)
        }
    }

    func deleteBackward() {
        currentText.accept(String(currentText.value.dropLast()))
    }

}
