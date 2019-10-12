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
    
    fileprivate let viewModel = CurrencyListViewModel()
    fileprivate let sections = PublishSubject<[RateListSection]>()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(viewModel.activeCurrency, viewModel.currencyRates)
            .map { activeCurrency, currencyRates -> Observable<[RateListSection]> in
                let sortedRates = currencyRates.sorted { modelA, modelB in modelA.currencyCode < modelB.currencyCode }
                
                return Observable.just([
                    RateListSection(model: "Active currency", items: [activeCurrency]),
                    RateListSection(model: "Exchange rates", items: sortedRates)
                ])
        }.flatMapLatest { return $0 }
        .asDriver(onErrorJustReturn: [])
        .drive(sections)
        .disposed(by: disposeBag)
        
         let dataSource = RxTableViewSectionedReloadDataSource<RateListSection>(
                   configureCell: { (_, tv, ip, currencyModel: CurrencyCellViewModel) in
                    guard let cell = tv.dequeueReusableCell(withIdentifier: "CurrencyCellView") as? CurrencyCellView
                        else {
                            print("Error dequeueing cell")
                            return UITableViewCell()
                    }
                    cell.configure(viewModel: currencyModel)
                    return cell
                   }
        )        
        
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CurrencyCellViewModel.self)
            .filter { [weak self] model in
                guard let strongSelf = self else { return false }
        
                return model != strongSelf.viewModel.activeCurrency.value
            }
            .bind(to: self.viewModel.activeCurrency)
            .disposed(by: disposeBag)        
    }

}
