//
//  FiltersVC.swift
//  pointee
//
//  Created by Alexander on 04.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

/**
 Class responsible for displaying side menu with all Filters.
 */
final class FiltersVC: UIViewController, ViewModelBased {
    
    // MARK: - UI Properties
    
    let tableView = UITableView()
    let clearButton = UIBarButtonItem()
    let applyButton = UIBarButtonItem()
    
    // MARK: - Properties
    
    var viewModel: FiltersVM!

    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = UIConstants.SpaceBlue
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.backgroundColor = UIConstants.SpaceBlue
        tableView.register(cellType: TypeFilterCell.self)
        tableView.register(cellType: TagsFilterCell.self)
        tableView.register(cellType: AverageCheckCell.self)
        tableView.estimatedRowHeight = 114
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.rightBarButtonItem = applyButton
    }
    
    func setupLocalize() {
        title = viewModel.topTitle
        clearButton.title = viewModel.clearTitle
        applyButton.title = viewModel.applyTitle
    }
    
    func bindUI() {
        setupTableDataSource()
        
        clearButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.clearAction)
            .disposed(by: disposeBag)
        
        applyButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.applyAction)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("FiltersVC deinit")
    }
    
    // MARK: - Logic
    
    /// Setup data source
    private func setupTableDataSource() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<FiltersVM.FilterSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .type(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TypeFilterCell.self)
                cell.configureCell(viewModel)
                return cell
            case .tags(let viewModel), .cuisines(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TagsFilterCell.self)
                cell.configureCell(viewModel)
                return cell
            case .averageCheck(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AverageCheckCell.self)
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
