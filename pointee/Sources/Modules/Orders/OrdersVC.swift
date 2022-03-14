//
//  OrdersVC.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

/**
 Class responsible for displaying list of completed orders.
 */
final class OrdersVC: UITableViewController, ViewModelBased {
    
    // MARK: - Properties
    
    var viewModel: OrdersVM!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.didAppear.onNext(())
        }
    }
    
    func setupUI() {
        tableView.register(cellType: OrderCell.self)
        tableView.estimatedRowHeight = 97
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIConstants.GreyBackground
    }
    
    func setupLocalize() {
        navigationItem.title = viewModel.topTitle
    }
    
    func bindUI() {
        setupTableDataSource()
        
        viewModel
            .appAction
            .observeOn(MainScheduler.instance)
            .bind(to: rx.appAction)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("OrdersVC deinit")
    }
    
    // MARK: - Logic
    
    private func setupTableDataSource() {
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<OrdersVM.OrderSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .order(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: OrderCell.self)
                cell.configureCell(viewModel)
                return cell
            }
        })
        
        viewModel
            .sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
