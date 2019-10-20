//
//  CurrencyListViewController.swift
//  ExchangeRates
//
//  Created by Vadim Zhepetov on 08/10/2019.
//  Copyright © 2019 Vadim Zhepetov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CurrencyListViewController: UIViewController {
                
    typealias RateListSection = SectionModel<String, CurrencyCellViewModel>
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var navigationView: UINavigationBar!
    
    fileprivate let viewModel = CurrencyListViewModel()
    fileprivate let sections = PublishSubject<[RateListSection]>()
    fileprivate let keyboardService = CurrencyKeyboardService()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindTableView()
        bindKeyboard()
    }
     
    func bindTableView() {
        Observable.combineLatest(viewModel.activeCurrency, viewModel.currencyRates)
            .map { activeCurrency, currencyRates -> Observable<[RateListSection]> in
                let sortedRates = currencyRates.sorted { modelA, modelB in modelA.currencyCode < modelB.currencyCode }
                
                return Observable.just([
                    RateListSection(model: "Active currency", items: [activeCurrency]),
                    RateListSection(model: "Exchange rates", items: sortedRates)
                    
                ])
        }
        .flatMapLatest { return $0 }
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: [])
        .drive(sections)
        .disposed(by: disposeBag)
        
         let dataSource = RxTableViewSectionedReloadDataSource<RateListSection>(
            configureCell: { (_, tv, ip, currencyModel: CurrencyCellViewModel) in
                let currencyView: CurrencyView? = ip.section == 0 ?
                    tv.dequeueReusableCell(withIdentifier: "ActiveCurrencyCellView") as? CurrencyView :
                    tv.dequeueReusableCell(withIdentifier: "CurrencyCellView") as? CurrencyView
                                
                currencyView?.configure(viewModel: currencyModel)
                
                if let cell = currencyView as? UITableViewCell {
                    return cell
                } else {
                    print("Error dequeueing cell")
                    return UITableViewCell()
                }
            }
        )
        
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CurrencyCellViewModel.self)
            .do(onNext: { [unowned self] _ in
                self.keyboardService.resetText()
            })
            .bind(to: self.viewModel.updateActiveCurrency)
            .disposed(by: disposeBag)
    }
    
    func bindKeyboard() {
        keyboardService.resetText()
        keyboardService.currentText
            .map { Double($0) ?? 0 }
            .bind(to: viewModel.currencyAmount)
            .disposed(by: disposeBag)
        
        // Adding keyboard control to navigation bar to avoid keyboard dismiss on UITableView reload in case when rates are updated
        navigationView.addSubview(keyboardService)
        
        tableView.rx.itemSelected
        .subscribe { [weak self] _ in
            self?.keyboardService.becomeFirstResponder()
        }
        .disposed(by: disposeBag)
    }
}
